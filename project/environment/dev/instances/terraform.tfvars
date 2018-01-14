terragrunt = {

  include {
    path = "${find_in_parent_folders()}"
  }

  terraform {
    source = "../../..///templates/instances"
  }
}

project = "jpinsolle"
# Relative path from templates
gce_ssh_pub_key_file = "../../environment/dev/google.pub"
labels = {
  owner = "jpinsolle"
}