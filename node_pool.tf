# ==============================================================================
# GKE Node Pools (System & Elastic Workloads)
# ==============================================================================

# 1. System Node Pool (Tainted for critical cluster components)
resource "google_container_node_pool" "system" {
  name       = "system-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.system_node_count

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = "e2-standard-2"
    image_type      = "COS_CONTAINERD"
    service_account = google_service_account.gke_nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    taint {
      key    = "CriticalAddonsOnly"
      value  = "true"
      effect = "NO_SCHEDULE"
    }

    labels = {
      role = "system"
      tier = "control-plane-addons"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}

# 2. User Workload Node Pool (Elastic Autoscaling)
resource "google_container_node_pool" "workloads" {
  name     = "workload-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name

  autoscaling {
    min_node_count = var.workload_node_min_count
    max_node_count = var.workload_node_max_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type    = "e2-standard-4"
    image_type      = "COS_CONTAINERD"
    service_account = google_service_account.gke_nodes.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    labels = {
      role        = "workload"
      environment = "production"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
}
