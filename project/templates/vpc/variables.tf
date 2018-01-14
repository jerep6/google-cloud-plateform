provider "google" {
  project = "${var.google-project}"
  region = "${var.google-region}"
  //  credentials = "${file("../jpinsolle-7a7f1ebe9f40.json")}"
}

// TODO : why I need this block?
terraform {
  backend "local" {}
}

variable "google-project" {}
variable "google-region" {}
variable "project" {}
variable "environment" {}

variable "subnets" {
  type = "map"
  default = {
    "europe-west1" = "192.168.50.0/24"
  }
}
