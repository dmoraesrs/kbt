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

module "logsink_gcs" {
  source      = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/logging-bucket"
  parent_type = "project"
  parent      = var.project_id
  retention   = 7
  id          = "logsink-gke-${var.project_id}"
}

module "sink_logbucket" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.logsink_log_sink.url}"
  filter                 = "resource.type = ('k8s_container' OR 'k8s_pod' OR 'k8s_cluster' OR 'gke_cluster' OR 'k8s_control_plane_component')"
  log_sink_name          = "sink_logbucket"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.logsink_gcs.id}"
  filter                 = "resource.type = ('k8s_container' OR 'k8s_pod' OR 'k8s_cluster' OR 'gke_cluster' OR 'k8s_control_plane_component')"
  log_sink_name          = "sinc_gcs"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}
