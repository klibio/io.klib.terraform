provider "kubernetes" {
}


resource "kubernetes_pod" "aries" {
  metadata {
    name = "aries-example"
    labels = {
      App = "aries"
    }
  }

  spec {
    container {
      image = "klibio/io.klib.aries.example:master-latest"
      name  = "example-test"

      port {
        container_port = 8080
      }
    }
  }
}

resource "kubernetes_service" "aries" {
  metadata {
    name = "aries-example"
  }
  spec {
    selector = {
      App = kubernetes_pod.aries.metadata[0].labels.App
    }
    port {
      port        = 8080
      target_port = 8080
    }

    type = "NodePort"
  }
}

output "np_ip" {
  value = kubernetes_service.aries.spec[0].port[0].node_port
}
