module.destination.google_logging_project_bucket_config.bucket: Creating...
╷
│ Error: Error creating Bucket: googleapi: Error 403: Permission 'logging.buckets.create' denied on resource (or it may not exist).
│ Details:
│ [
│   {
│     "@type": "type.googleapis.com/google.rpc.ErrorInfo",
│     "domain": "iam.googleapis.com",
│     "metadata": {
│       "permission": "logging.buckets.create"
│     },
│     "reason": "IAM_PERMISSION_DENIED"
│   }
│ ]
│ 
│   with module.destination.google_logging_project_bucket_config.bucket,
│   on .terraform/modules/destination/modules/logbucket/main.tf line 36, in resource "google_logging_project_bucket_config" "bucket":
│   36: resource "google_logging_project_bucket_config" "bucket" {
│ 
╵
╷
│ Error: Error creating Bucket: googleapi: Error 403: Permission 'logging.buckets.create' denied on resource (or it may not exist).
│ Details:
│ [
│   {
│     "@type": "type.googleapis.com/google.rpc.ErrorInfo",
│     "domain": "iam.googleapis.com",
│     "metadata": {
│       "permission": "logging.buckets.create"
│     },
│     "reason": "IAM_PERMISSION_DENIED"
│   }
│ ]
│ 
│   with module.logsink_gcs.google_logging_project_bucket_config.bucket[0],
│   on .terraform/modules/logsink_gcs/modules/logging-bucket/main.tf line 17, in resource "google_logging_project_bucket_config" "bucket":
│   17: resource "google_logging_project_bucket_config" "bucket" {
│ 
╵
##[error]Bash exited with code '1'.
