terragrunt = {

  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "../../..///templates/vpc"
  }
}

project = "jpinsolle"
network-name = "jpinsolle"