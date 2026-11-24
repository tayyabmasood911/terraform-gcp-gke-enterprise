# ==============================================================================
# GKE Enterprise Private Cluster Specification
# ==============================================================================

resource "google_container_cluster" "primary" {
  provider = google-beta

  name     = var.cluster_name
  location = var.region

  # We create a separately managed node pool, so remove default pool immediately
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet.id

  # 1. IP Allocation Policy for Pods and Services
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_cidr_name
    services_secondary_range_name = var.services_cidr_name
  }

  # 2. Private Cluster Configuration
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # 3. Master Authorized Networks
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "Global Authorized Management"
    }
  }

  # 4. Datapath V2 (Cilium eBPF Engine)
  datapath_provider = "ADVANCED_DATAPATH"

  # 5. Workload Identity Federation
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # 6. Release Channel & Maintenance
  release_channel {
    channel = var.release_channel
  }

  # 7. Addons Configuration
  addons_config {
    http_load_balancing {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
    gcs_fuse_csi_driver_config {
      enabled = true
    }
  }

  # 8. Shielded Nodes
  shielded_nodes {
    enabled = true
  }

  # 9. Logging & Monitoring
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  # Prevent accidental destruction of production cluster
  lifecycle {
    ignore_changes = [initial_node_count]
  }
}
