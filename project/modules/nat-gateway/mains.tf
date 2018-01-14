data "template_file" "nat-startup-script" {
  template = <<EOF
#!/bin/bash -xe

# Enable ip forwarding and nat
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

apt-get update

# Install nginx for instance http health check
apt-get install -y nginx

EOF
}

data "google_compute_network" "network" {
  name    = "${var.network}"
  project = "${var.project}"
}

module "nat-gateway" {
  source            = "../managed-instance-group"
  project           = "${var.project}"
  region            = "${var.region}"
  zone              = "${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}"
  network           = "${var.network}"
  subnetwork        = "${var.subnetwork}"
  target_tags       = ["nat-${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}"]
  machine_type      = "${var.machine_type}"
  name              = "nat-gateway-${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}"
  compute_image     = "debian-cloud/debian-9"
  size              = 1
  network_ip        = "${var.ip}"
  can_ip_forward    = "true"
  service_port      = "80"
  service_port_name = "http"
  startup_script    = "${data.template_file.nat-startup-script.rendered}"

  // Race condition when creating route with instance in managed instance group. Wait 30 seconds for the instance to be created by the manager.
  local_cmd_create = "sleep 30"

  access_config = [{
    nat_ip = "${google_compute_address.default.address}"
  }]
}

resource "google_compute_route" "nat-gateway" {
  name                   = "nat-${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}"
  dest_range             = "0.0.0.0/0"
  network                = "${data.google_compute_network.network.self_link}"
  next_hop_instance      = "${element(split("/", element(module.nat-gateway.instances[0], 0)), 10)}"
  next_hop_instance_zone = "${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}"
  tags                   = ["${compact(concat(list("nat-${var.region}"), var.tags))}"]
  priority               = "${var.route_priority}"
}

resource "google_compute_firewall" "nat-gateway" {
  name    = "nat-${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}"
  network = "${var.network}"

  allow {
    protocol = "all"
  }

  source_tags = ["${var.tags}"]
  target_tags = ["${compact(concat(list("nat-${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}")))}"]
}

resource "google_compute_address" "default" {
  name = "nat-${var.zone == "" ? lookup(var.region_params["${var.region}"], "zone") : var.zone}"
}
