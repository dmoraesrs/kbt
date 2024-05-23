Este cluster tem um webhook de admissão instalado que está interceptando solicitações críticas do sistema nas últimas 24 horas. A interceptação dessas solicitações pode afetar a disponibilidade do plano de controle do GKE.


kubectl get validatingwebhookconfigurations
kubectl get mutatingwebhookconfigurations



module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.logsink_gcs.destination_uri}"
  filter                 = "resource.type = ("k8s_container" OR "k8s_pod" OR "k8s_cluster" OR "gke_cluster" OR "k8s_control_plane_component")"
  log_sink_name          = "sinc_gcs-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}
