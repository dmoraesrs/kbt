│ Error: googleapi: Error 400: Sink.destination with unknown service name: projects. Supported services are bigquery.googleapis.com,pubsub.googleapis.com,storage.googleapis.com,logging.googleapis.com, badRequest
│ 
│   with module.sink_gcs.google_logging_project_sink.sink[0],
│   on .terraform/modules/sink_gcs/main.tf line 41, in resource "google_logging_project_sink" "sink":
│   41: resource "google_logging_project_sink" "sink" {
│ 
╵
╷
│ Error: googleapi: Error 400: Sink.destination with unknown service name: gs:. Supported services are bigquery.googleapis.com,pubsub.googleapis.com,storage.googleapis.com,logging.googleapis.com, badRequest
│ 
│   with module.sink_logbucket.google_logging_project_sink.sink[0],
│   on .terraform/modules/sink_logbucket/main.tf line 41, in resource "google_logging_project_sink" "sink":
│   41: resource "google_logging_project_sink" "sink" {
