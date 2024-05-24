module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/logbucket"
  version = "~> 8.0"

  project_id               = var.project_id
  name                     = "gcs-logsink-gke-${var.env}-${var.product}-${var.project_id}"
  location                 = "global"
  log_sink_writer_identity = module.log_export.writer_identity
  retention_days           = 7  # Adicionado para definir a retenção de logs
}

module "logsink_gcs" {
  source      = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/logging-bucket"
  parent_type = "project"
  parent      = var.project_id
  retention   = 7
  id          = "logsink-gke-${var.env}-${var.product}-${var.project_id}"
}

module "sink_logbucket" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = module.destination.destination_uri
  filter                 = "severity >= ERROR"
  log_sink_name          = "sink_logbucket-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = module.destination.destination_uri
  filter                 = "resource.type = ('k8s_container' OR 'k8s_pod' OR 'k8s_cluster' OR 'gke_cluster' OR 'k8s_control_plane_component')"
  log_sink_name          = "sink_gcs-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}



Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: invalid value for member (IAM members must have one of the values outlined here: https://cloud.google.com/billing/docs/reference/rest/v1/Policy#Binding)
│ 
│   with module.destination.google_project_iam_member.logbucket_sink_member[0],
│   on .terraform/modules/destination/modules/logbucket/main.tf line 73, in resource "google_project_iam_member" "logbucket_sink_member":
│   73:   member  = var.log_sink_writer_identity
