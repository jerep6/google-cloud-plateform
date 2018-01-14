variable project {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable network {
  description = "The network to deploy to"
}

variable subnetwork {
  description = "The subnetwork to deploy to"
}

variable region {
  description = "The region to create the nat gateway instance in."
}

variable zone {
  description = "Override the zone used in the `region_params` map for the region."
  default     = ""
}

variable tags {
  description = "Additional compute instance network tags to apply route to."
  type        = "list"
  default     = []
}

variable route_priority {
  description = "The priority for the Compute Engine Route"
  default     = 800
}

variable machine_type {
  description = "The machine type for the NAT gateway instance"
  default     = "n1-standard-1"
}

variable ip {
  description = "Override the IP used in the `region_params` map for the region."
  default     = ""
}

variable region_params {
  description = "Map of default zones and IPs for each region. Can be overridden using the `zone` and `ip` variables."
  type        = "map"

  default = {
    us-west1 {
      zone = "us-west1-b"
    }

    us-central1 {
      zone = "us-central1-f"
    }

    us-east1 {
      zone = "us-east1-b"
    }

    us-east4 {
      zone = "us-east4-b"
    }

    europe-west1 {
      zone = "europe-west1-b"
    }

    europe-west2 {
      zone = "europe-west2-b"
    }

    europe-west3 {
      zone = "europe-west3-b"
    }

    asia-southeast1 {
      zone = "asia-southeast1-b"
    }

    asia-east1 {
      zone = "asia-east1-b"
    }

    asia-northeast1 {
      zone = "asia-northeast1-b"
    }

    australia-southeast1 {
      zone = "australia-southeast1-b"
    }

    asia-south1 {
      zone = "asia-south1-b"
    }

    southamerica-east1 {
      zone = "southamerica-east1-b"
    }
  }
}
