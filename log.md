module "sink_logbucket" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = module.destination.destination_uri
  filter                 = "severity >= ERROR"
  log_sink_name          = "sink_logbucket-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
  retention_days         = 7  # Adicionado para definir a retenção de logs
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
  retention_days         = 7  # Adicionado para definir a retenção de logs
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
  retention_days         = 7  # Adicionado para definir a retenção de logs
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
  retention_days         = 7  # Adicionado para definir a retenção de logs
}
