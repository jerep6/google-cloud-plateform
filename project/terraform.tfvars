terragrunt = {
  remote_state {
    backend = "local"
    config {
      path = "${get_tfvars_dir()}/terraform.state"
    }
  }

  terraform {
    extra_arguments "custom_vars" {
      commands = [
        "apply",
        "plan",
        "import",
        "push",
        "refresh",
        "destroy"
      ]

      # With the get_tfvars_dir() function, you can use relative paths!
      arguments = [
        "-var-file=${get_tfvars_dir()}/../../common-variables.tfvars",
        "-var-file=${get_tfvars_dir()}/../environment-common-variables.tfvars",
        "-var-file=terraform.tfvars"
      ]
    }
  }
}
