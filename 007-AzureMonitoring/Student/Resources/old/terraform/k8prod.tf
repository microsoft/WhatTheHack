provider "kubernetes" {

  host                   = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.host}"
  #
  # BC - Removed these as per github issue https://github.com/terraform-providers/terraform-provider-kubernetes/issues/175
  #
  #username               = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.username}"
  #password               = "${azurerm_kubernetes_cluster.akscluster.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.akscluster.kube_config.0.cluster_ca_certificate)}"

  }

resource "kubernetes_namespace" "example" {
  metadata {
    name = "${var.namespace}"
  }
}

#
# BC - Changed to 'deployment' rather than a 'pod'
#
resource "kubernetes_deployment" "web" {
  metadata {
    name = "nginx"

    labels {
      name = "nginx"
    }

    namespace = "${kubernetes_namespace.example.metadata.0.name}"
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        name = "nginx"
      }
    }

    template {
      metadata {
        labels {
          name = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.7.9"
          name  = "nginx"
        }
      }
    }
  }
}

resource "kubernetes_service" "web" {
  metadata {
    name      = "nginx"
    namespace = "${kubernetes_namespace.example.metadata.0.name}"
  }

  spec {
    selector {
      name = "${kubernetes_deployment.web.metadata.0.labels.name}"
    }

    session_affinity = "ClientIP"

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}