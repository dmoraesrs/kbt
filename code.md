

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  version                  = "~> 7.0"
  project_id               = var.project_id
  storage_bucket_name      = "storage-logs-${var.env}-${var.product}-${var.project_id}"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
}



# Defina o módulo logsink_gcs separadamente
module "logsink_gcs" {
  source      = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/logging-bucket"
  parent_type = "project"
  parent      = var.project_id
  retention   = 7
  id          = "logs-gke-${var.env}-${var.product}-${var.project_id}"
}



module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          ="storage-logs-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

# Defina o log sink para recursos do Kubernetes
module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = module.destination.destination_uri
  filter                 = "resource.type = ('k8s_container' OR 'k8s_pod' OR 'k8s_cluster' OR 'gke_cluster' OR 'k8s_control_plane_component')"
  log_sink_name          = "sink-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
  depends_on = [ module.destination ]
}
