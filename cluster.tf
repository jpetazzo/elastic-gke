resource "google_container_cluster" "_" {
  name            = local.name
  location        = local.zone

  networking_mode = "VPC_NATIVE"
  network         = google_compute_network._.name
  subnetwork      = google_compute_subnetwork._.name
  ip_allocation_policy {
    # This is the block that will be used for pods.
    # It must be distinct from the subnet used for nodes.
    cluster_ipv4_cidr_block = local.pods_cidr
  }

  # We won't use that node pool but we have to declare it anyway.
  # It will remain empty so we don't have to worry about it.
  node_pool {
    name = "builtin"
  }
  lifecycle {
    ignore_changes = [node_pool]
  }
}

# Important: the cluster needs to have at least one node, otherwise
# nothing will work. (We would expect the cluster autoscaler to kick
# in and scale up from zero, but that doesn't work.)
# This means that at least one node pool should have at least one node.
# Also, note that setting min_node_count to 1 (or more) isn't enough
# to create a node! As far as I understand, the min_node_count value
# means "do not scale down below that", but it doesn't set the *initial*
# size of the node pool. This means that we must set initial_node_count
# to a non-zero value for at least one node pool.

resource "google_container_node_pool" "ondemand" {
  name    = "ondemand"
  cluster = google_container_cluster._.id
  autoscaling {
    min_node_count = 0
    max_node_count = 5
  }
  node_config {
    preemptible = false
  }
}

resource "google_container_node_pool" "preemptible" {
  name               = "preemptible"
  cluster            = google_container_cluster._.id
  initial_node_count = 1
  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }
  node_config {
    preemptible = true
  }
}

