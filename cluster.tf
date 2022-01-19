resource "google_container_cluster" "_" {
  name = local.name
  location = local.zone

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    # This is the block that will be used for pods.
    cluster_ipv4_cidr_block = "10.16.0.0/12"
  }
  network = google_compute_network._.name
  subnetwork = google_compute_subnetwork._.name

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "ondemand" {
  name       = "ondemand"
  cluster    = google_container_cluster._.id
  autoscaling {
    min_node_count = 0
    max_node_count = 5
  }
  node_config {
    preemptible  = false
  }
}

resource "google_container_node_pool" "preemptible" {
  name       = "preemptible"
  cluster    = google_container_cluster._.id
  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }
  node_config {
    preemptible  = true
  }
}

