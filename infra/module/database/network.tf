resource "google_compute_network" "db_network" {
  name                    = "db-network"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "db_private_ip" {
  name          = "db-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = "10.0.0.0"
  prefix_length = 16
  network       = google_compute_network.db_network.id
}

resource "google_service_networking_connection" "db_conn" {
  network                 = google_compute_network.db_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.db_private_ip.name]
}

resource "google_vpc_access_connector" "connector" {
  name          = "vpc-access-con"
  ip_cidr_range = "10.10.0.0/28"
  network       = google_compute_network.db_network.id
}
