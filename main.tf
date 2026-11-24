# ==============================================================================
# Google Cloud VPC, Subnets & Cloud NAT for GKE Enterprise
# ==============================================================================

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  ip_cidr_range            = var.subnet_cidr
  region                   = var.region
  network                  = google_compute_network.vpc.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = var.pods_cidr_name
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = var.services_cidr_name
    ip_cidr_range = var.services_cidr
  }
}

# Cloud Router for NAT Gateway Egress
resource "google_compute_router" "router" {
  name    = "cr-${var.network_name}-${var.region}"
  region  = var.region
  network = google_compute_network.vpc.id
}

# Cloud NAT for private nodes egress without external IPs
resource "google_compute_router_nat" "nat" {
  name                               = "nat-${var.network_name}-${var.region}"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# IAM Service Account for GKE Nodes
resource "google_service_account" "gke_nodes" {
  account_id   = "sa-gke-enterprise-nodes"
  display_name = "GKE Enterprise Worker Nodes Service Account"
}

resource "google_project_iam_member" "node_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer",
    "roles/artifactregistry.reader"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}
