resource "google_container_cluster" "mycluster" {
  name = "tuesday"
  location = "europe-north1-a"
  #location = "europe-north1"
  initial_node_count = 2
}
