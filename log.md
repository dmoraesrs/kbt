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



╷
│ Error: Cycle: module.destination.var.kms_key_name (expand), module.destination.var.name (expand), module.destination.var.location (expand), module.destination.var.retention_days (expand), module.destination.var.locked (expand), module.destination.var.project_id (expand), module.destination.google_project_service.enable_destination_api, module.sink_logbucket.output.writer_identity (expand), module.sink_logbucket.output.parent_resource_id (expand), module.sink_logbucket.local.log_sink_resource_id (expand), module.sink_logbucket.output.log_sink_resource_id (expand), module.sink_logbucket.local.log_sink_parent_id (expand), module.sink_logbucket.local.log_sink_writer_identity (expand), module.sink_logbucket (close), module.sink_logbucket.google_logging_project_sink.sink, module.sink_logbucket.google_logging_billing_account_sink.sink, module.sink_logbucket.google_logging_organization_sink.sink, module.destination.local.log_bucket_id (expand), module.destination.local.destination_uri (expand), module.destination.output.destination_uri (expand), module.sink_logbucket.var.destination_uri (expand), module.sink_logbucket.google_logging_folder_sink.sink, module.sink_logbucket.local.log_sink_resource_name (expand), module.sink_logbucket.output.log_sink_resource_name (expand), module.destination (expand), module.destination.var.enable_analytics (expand), module.destination.google_logging_project_bucket_config.bucket
│ 
│ 
╵
