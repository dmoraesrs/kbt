codigo:1

module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "storage-${var.env}-${var.product}-${var.project_id}"
  parent_resource_id     = var.id_projeto
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  version                  = "~> 7.0"
  project_id               = var.id_projeto
  storage_bucket_name      = "storage-${var.env}-${var.product}-${var.project_id}"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
}

#####################################################################
#####################################################################


# Defina o módulo logsink_gcs separadamente
module "logsink_gcs" {
  source      = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/logging-bucket"
  parent_type = "project"
  parent      = var.project_id
  retention   = 7
  id          = "logsink-gke-${var.env}-${var.product}-${var.project_id}"
}

# Defina o log sink para recursos do Kubernetes
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




codigo: 2

module "logsink_log_sink" {
  source        = "github.com/terraform-google-modules/cloud-foundation-fabric//modules/gcs"
  project_id    = var.project_id
  prefix        = var.prefix
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
  destination_uri        = "${module.logsink_log_sink.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "sink_logbucket"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}

module "sink_gcs" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.logsink_gcs.destination_uri}"
  filter                 = "resource.type = ("k8s_container" OR "k8s_pod" OR "k8s_cluster" OR "gke_cluster" OR "k8s_control_plane_component")"
  log_sink_name          = "sinc_gcs"
  parent_resource_id     = var.project_id
  parent_resource_type   = "project"
  unique_writer_identity = true
}












