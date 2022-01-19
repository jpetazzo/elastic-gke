resource "google_compute_network" "_" {
  name = local.name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "_" {
  name          = local.name
  ip_cidr_range = "10.0.0.0/10"
  region        = local.region
  network       = google_compute_network._.id
}

