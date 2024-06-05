variable "allowed_ports" {
  description = "List of allowed ports for the firewall rule"
  type        = list(string)
  default     = ["22", "3389"]
}


resource "google_compute_firewall" "fw-rule-2" {
  project = "merc-shared-vpc-${var.env}-002"
  name    = "allow-iap"
  network = module.vpc.network_name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = ["35.235.240.0/20"]
}
