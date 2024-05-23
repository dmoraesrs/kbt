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













module "logsink_log_sink" {
  source        = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gcs"
  project_id    = var.project_id
  prefix        = var.prefix
  name          = "gcs-logsink-gke-${var.env}-${var.product}-${var.project_id}"
  versioning    = true
  labels        = {
    env = "sandbox"
  }
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
  destination_uri        = "${module.}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "sink_logbucket-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = module.sink_gcs.destination_uri.
  filter                 = "resource.type = ('k8s_container' OR 'k8s_pod' OR 'k8s_cluster' OR 'gke_cluster' OR 'k8s_control_plane_component')"
  log_sink_name          = "sink_gcs-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}


