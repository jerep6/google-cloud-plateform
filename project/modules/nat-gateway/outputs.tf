
output depends_id {
  description = "Value that can be used for intra-module dependency creation."
  value       = "${module.nat-gateway.depends_id}"
}

output gateway_ip {
  description = "The internal IP address of the NAT gateway instance."
  value       = "${module.nat-gateway.network_ip}"
}

output external_ip {
  description = "The external IP address of the NAT gateway instance."
  value       = "${google_compute_address.default.address}"
}
