Este cluster tem um webhook de admissão instalado que está interceptando solicitações críticas do sistema nas últimas 24 horas. A interceptação dessas solicitações pode afetar a disponibilidade do plano de controle do GKE.


kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations



module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = module.logsink_gcs.destination_uri
  filter                 = "resource.type = ('k8s_container' OR 'k8s_pod' OR 'k8s_cluster' OR 'gke_cluster' OR 'k8s_control_plane_component')"
  log_sink_name          = "sink_gcs-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}








module "destination" {
  source  = "terraform-google-modules/log-export/google//modules/logbucket"
  version = "~> 8.0"

  project_id               = var.project_id
  name                     = "gcs-logsink-gke-${var.env}-${var.product}-${var.project_id}"
  location                 = "global"
  log_sink_writer_identity = module.log_export.writer_identity
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
│ Error: Unsupported attribute
│ 
│   on storage.tf line 23, in module "sink_logbucket":
│   23:   destination_uri        = module.logsink_gcs.destination_uri
│     ├────────────────
│     │ module.logsink_gcs is a object
│ 
│ This object does not have an attribute named "destination_uri".
╵
╷
│ Error: Unsupported attribute
│ 
│   on storage.tf line 34, in module "sink_gcs":
│   34:   destination_uri        = module.logsink_log_sink.destination_uri
│     ├────────────────
│     │ module.logsink_log_sink is a object
│ 
│ This object does not have an attribute named "destination_uri".
