provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}

resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "nginx-config"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }
  data = {
    demo_title   = "K8s Demo via Terraform"
    "index.html" = <<EOT
<html>
  <head><title>Demo</title></head>
  <body>
    <h1>K8s Demo via Terraform</h1>
    <p>Welcome to NGINX running on Kubernetes (Terraform)!</p>
  </body>
</html>
EOT
  }
}

resource "kubernetes_secret" "nginx_secrets" {
  metadata {
    name      = "nginx-secrets"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }
  data = {
    DEMO_PASSWORD = base64encode(var.demo_password)
  }
  type = "Opaque"
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-demo"
    namespace = kubernetes_namespace.demo.metadata[0].name
    labels = {
      app = "nginx-demo"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx-demo"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx-demo"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:1.25"
          port {
            container_port = 80
          }
          env {
            name = "DEMO_TITLE"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.nginx_config.metadata[0].name
                key  = "demo_title"
              }
            }
          }
          env {
            name = "DEMO_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.nginx_secrets.metadata[0].name
                key  = "DEMO_PASSWORD"
              }
            }
          }
          resources {
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
          }

          volume_mount {
            name       = "html"
            mount_path = "/usr/share/nginx/html/"
            sub_path   = ""
          }

        }
        volume {
          name = "html"
          config_map {
            name = kubernetes_config_map.nginx_config.metadata[0].name
            items {
              key  = "index.html"
              path = "index.html"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30080
    }
    type = "NodePort"
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "nginx" {
  metadata {
    name      = "nginx-hpa"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }
  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.nginx.metadata[0].name
    }
    min_replicas = 2
    max_replicas = 5
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "nginx_ingress" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.demo.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    rule {
      host = "nginx-demo.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.nginx.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
