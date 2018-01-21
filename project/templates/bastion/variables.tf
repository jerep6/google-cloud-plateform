provider "google" {
  project = "${var.google-project}"
  region = "${var.google-region}"
}
terraform {
  backend "local" {}
}

variable "google-project" {}
variable "google-region" {}
variable "project" {}
variable "environment" {}
variable "user" {}
variable "gce_ssh_pub_key_file" {
  description = "Content of the public key to pub on the instance"
  default = ""
}

variable "machine-type" {
  default = "f1-micro"
}

variable "labels" {
  type = "map"
  default = {}
}
