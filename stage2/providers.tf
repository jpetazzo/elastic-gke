
data "google_client_config" "_" {
}

data "google_container_cluster" "_" {
  name     = "onemoretime"
  location = "europe-north1-a"
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster._.endpoint}"
  token = data.google_client_config._.access_token
  cluster_ca_certificate = base64decode(
  data.google_container_cluster._.master_auth[0].cluster_ca_certificate)
}
