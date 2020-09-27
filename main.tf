provider "kubernetes" {}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    labels = {
      App = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          App = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

          command = ["nginx", "-g", "daemon off;"]

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx-service" {
  metadata {
    name = "nginx-service"
  }
  spec {
    type = "ClusterIP"
    selector = {
      "App" = "${kubernetes_deployment.nginx.spec[0].template[0].metadata[0].labels.App}"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}