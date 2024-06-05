resource "google_compute_firewall" "fw-rule-2" {
  project = "merc-shared-vpc-${var.env}-002"
  name    = "allow-iap"
  network = module.vpc.network_name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
  }

  source_ranges = ["35.235.240.0/20"]
}
