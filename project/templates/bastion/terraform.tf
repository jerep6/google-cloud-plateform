provider "google" {
  project     = "xebia-sandbox"
  region      = "europe-west1"
//  credentials = "${file("../jpinsolle-7a7f1ebe9f40.json")}"
}


data "terraform_remote_state" "network" {
  backend = "local"

  config {
    path = "${path.module}/../vpc/terraform.tfstate"
  }
}

variable "gce_ssh_user" {
  default = "jpinsolle"
}
variable "gce_ssh_pub_key_file" {
  default = "google.pub"
}


data "google_compute_network" "network" {
  name    = "jpinsolle-vpc"
}


resource "google_compute_address" "bastion" {
  name = "jpinsolle-bastion-ip"
}


resource "google_compute_instance" "default" {
  name         = "jpinsolle-bastion"
  machine_type = "f1-micro"
  zone         = "europe-west1-b"

  tags = ["allow-ssh", "public", "bastion"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      type= "pd-standard"
    }
  }

  network_interface {
    subnetwork = "${data.terraform_remote_state.network.subnetwork_name}"

    access_config {
      nat_ip = "${google_compute_address.bastion.address}"
    }
  }

  metadata {
    owner = "jpinsolle"
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

}
