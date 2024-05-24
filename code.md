# Primeiro, defina o bucket de destino separadamente
module "logsink_log_sink" {
  source        = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gcs"
  project_id    = var.project_id
  prefix        = var.prefix
  location      = var.default_region
  storage_class = "REGIONAL"
  name          = "gcs-logsink-gke-${var.project_id}"
  versioning    = true
  labels        = {
    cost-center = "bkl"
  }
}

# Defina o módulo logsink_gcs separadamente
module "logsink_gcs" {
  source      = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/logging-bucket"
  parent_type = "project"
  parent      = var.project_id
  retention   = 7
  id          = "logsink-gke-${var.project_id}"
}

# Defina o log sink para erros graves
module "sink_logbucket" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "storage.googleapis.com/${module.logsink_log_sink.name}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "sink_logbucket"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

# Defina o log sink para recursos do Kubernetes
module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "storage.googleapis.com/${module.logsink_gcs.id}"
  filter                 = "resource.type IN ('k8s_container', 'k8s_pod', 'k8s_cluster', 'gke_cluster', 'k8s_control_plane_component')"
  log_sink_name          = "sink_gcs"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}



terraform state rm module.logsink_gcs.google_logging_project_bucket_config.bucket[0]

