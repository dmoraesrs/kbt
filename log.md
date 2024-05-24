│ Error: Unsupported attribute
│ 
│   on storage.tf line 9, in module "destination":
│    9:   log_sink_writer_identity = module.sink_logbucket.unique_writer_identity
│     ├────────────────
│     │ module.sink_logbucket is a object
│ 
│ This object does not have an attribute named "unique_writer_identity".
