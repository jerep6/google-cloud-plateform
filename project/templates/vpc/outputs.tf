
output "network_name" {
  value = "${google_compute_network.network.name}"
}

output "subnetworks_name" {
  value = "${google_compute_subnetwork.subnetwork.*.name}"
}

output "subnetworks" {
  value = "${zipmap(keys(var.subnets), google_compute_subnetwork.subnetwork.*.name)}"
}
