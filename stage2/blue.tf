resource "kubernetes_deployment" "blue" {
  metadata {
    name      = "blue"
    namespace = "default"
  }
  spec {
    selector {
      match_labels = {
        app = "blue"
      }
    }
    template {
      metadata {
        labels = {
          app = "blue"
        }
      }
      spec {
        container {
          name  = "blue"
          image = "jpetazzo/color"
        }
      }
    }
  }
}

resource "kubernetes_service" "blue" {
  metadata {
    name      = "blue"
    namespace = "default"
  }
  spec {
    type = "LoadBalancer"
    selector = {
      app = "blue"
    }
    port {
      name        = "http"
      port        = 80
      target_port = 80
    }
  }
}
