│ Error: Error updating Logging Bucket Config "projects/merc-service-sandbox-dev-001/locations/global/buckets/logsink-gke-dev-sandbox-merc-service-sandbox-dev-001": googleapi: Error 400: Buckets must be in an ACTIVE state to be modified
│ 
│   with module.logsink_gcs.google_logging_project_bucket_config.bucket[0],
│   on .terraform/modules/logsink_gcs/modules/logging-bucket/main.tf line 17, in resource "google_logging_project_bucket_config" "bucket":
│   17: resource "google_logging_project_bucket_config" "bucket" {
