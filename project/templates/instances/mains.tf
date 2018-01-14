// TODO : why I need this block?
terraform {
  backend "local" {}
}

data "terraform_remote_state" "network" {
  backend = "local"

  config {
    path = "../../environment/${var.environment}/vpc/terraform.state"
  }
}

locals {
  labels = "${merge(var.labels, map(
                      "environment", "${var.environment}",
                      "project", "${var.project}"))}"
}

resource "google_compute_instance_template" "app-ias" {
  name_prefix = "${var.environment}-${var.project}-app-ias-"
  description = "This template is used to create app server instances."

  tags = [
    "allow-ssh",
    "private",
    "app-ias"]

  labels = "${local.labels}"

  instance_description = "app-ias"
  machine_type = "${var.machine-type}"
  can_ip_forward = false

  scheduling {
    automatic_restart = false
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = "debian-cloud/debian-9"
    auto_delete = true
    boot = true
  }


  network_interface {
    subnetwork = "${data.terraform_remote_state.network.subnetworks_name[0]}"
  }

  metadata {
    owner = "${var.user}"
    sshKeys = "${var.user}:${file(var.gce_ssh_pub_key_file)}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Regional instance group
resource "google_compute_region_instance_group_manager" "app-ias" {
  name = "${var.environment}-${var.project}-app-ias"

  base_instance_name = "${var.environment}-${var.project}-app-ias"
  instance_template = "${google_compute_instance_template.app-ias.self_link}"
  region = "${var.google-region}"

  target_size = 2

  named_port {
    name = "custom"
    port = 8888
  }

  //  auto_healing_policies {
  //    health_check      = "${google_compute_health_check.app-ias.self_link}"
  //    initial_delay_sec = 300
  //  }

}

// Autoscaling
resource "google_compute_region_autoscaler" "app-ias" {
  name = "${var.environment}-${var.project}-app-ias"
  region = "${var.google-region}"
  target = "${google_compute_region_instance_group_manager.app-ias.self_link}"

  autoscaling_policy = {
    max_replicas = 4
    min_replicas = 1
    cooldown_period = 120

    cpu_utilization {
      target = 0.8
      // TODO: not possible to dissociate scale-in and scale-down metric
    }
  }
}


resource "google_compute_health_check" "app-ias" {
  name = "${var.environment}-${var.project}-app-ias"
  check_interval_sec = 5
  timeout_sec = 5
  healthy_threshold = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/health"
    port = "3000"
  }
}
