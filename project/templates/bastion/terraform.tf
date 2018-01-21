locals {
  labels = "${merge(var.labels, map(
                      "environment", "${var.environment}",
                      "project", "${var.project}"))}"
}

data "terraform_remote_state" "network" {
  backend = "local"

  config {
    path = "../../environment/${var.environment}/vpc/terraform.state"
  }
}

resource "google_compute_address" "bastion" {
  name = "${var.environment}-${var.project}-bastion"
}


resource "google_compute_instance_template" "bastion" {
  name_prefix = "${var.environment}-${var.project}-bastion-"
  description = "This template is used to create a bastion server"

  tags = [
    "allow-ssh",
    "public",
    "bastion"]

  labels = "${local.labels}"

  instance_description = "bastion"
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
    subnetwork = "${lookup(data.terraform_remote_state.network.subnetworks, var.google-region)}"

    access_config {
      nat_ip = "${google_compute_address.bastion.address}"
    }
  }
  metadata_startup_script = "apt-get install -y netcat"

  metadata {
    owner = "${var.user}"
    sshKeys = "${var.user}:${file(var.gce_ssh_pub_key_file)}"
//    startup-script = "apt-get install -y netcat"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "bastion" {
  name = "${var.environment}-${var.project}-bastion"

  base_instance_name = "${var.environment}-${var.project}-bastion"
  instance_template = "${google_compute_instance_template.bastion.self_link}"
  region = "${var.google-region}"

  target_size = 1

}