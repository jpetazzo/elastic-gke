resource "google_container_cluster" "mycluster" {
  name = "wednesday"
  location = "europe-north1-a"

  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    # This is the block that will be used for pods.
    cluster_ipv4_cidr_block = "10.0.0.0/12"
  }

  # We won't use that node pool but we have to declare it anyway.
  # It will remain empty so we don't have to worry about it.
  node_pool {
    name       = "builtin"
  }
  lifecycle {
    ignore_changes = [ node_pool ]
  }
}

resource "google_container_node_pool" "ondemand" {
  name       = "ondemand"
  cluster    = google_container_cluster.mycluster.id
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
  cluster    = google_container_cluster.mycluster.id
  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }
  node_config {
    preemptible  = true
  }
}


