locals {
  network-name = "${var.environment}-${var.project}"
}


resource "google_compute_network" "network" {
  name = "${local.network-name}"
  auto_create_subnetworks = "false"
}


resource "google_compute_subnetwork" "subnetwork" {
  count = "${length(var.subnets)}"
  name = "${local.network-name}-${element(keys(var.subnets), count.index)}"
  region = "${element(keys(var.subnets), count.index)}"
  ip_cidr_range = "${lookup(var.subnets, element(keys(var.subnets), count.index))}"
  private_ip_google_access = "true"
  network = "${google_compute_network.network.name}"
}


//module "nat-gateway" {
//  source = "../../modules/nat-gateway"
//  network = "${google_compute_network.network.name}"
//  subnetwork = "${google_compute_subnetwork.europe-west-1.name}"
//  region = "europe-west1"
//  tags = [
//    "private"]
//  machine_type = "f1-micro"
//}

// Rule to allow ssh
resource "google_compute_firewall" "allow-ssh" {
  name = "${local.network-name}-allow-ssh"
  network = "${local.network-name}"

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  target_tags = ["allow-ssh"]
}

//// Rule to allow ssh
resource "google_compute_firewall" "all-from-bastion" {
  name = "${local.network-name}-allow-all-from-bastion"
  network = "${local.network-name}"

  allow {
    protocol = "all"
  }

  source_tags = ["bastion"]
}
