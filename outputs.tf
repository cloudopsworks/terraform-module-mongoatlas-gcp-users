##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works/
#     Distributed Under Apache v2.0 License
#

output "users" {
  description = "User metadata map enriched with the GCP Secret Manager secret ID for each user's credentials."
  value = {
    for k, v in module.mongoatlas_users.users : k => merge(v, {
      secrets_credentials = google_secret_manager_secret.atlas_cred[k].id
    })
  }
}

output "hoop_connections" {
  description = "Hoop connection definitions enriched with GCP Secret Manager secret references. Pass as the `connections` input to terraform-module-hoop-connection. Community mode returns null (no _gcp agent provider); enterprise mode uses _envs/gcp/<secret-id>."
  value = module.mongoatlas_users.hoop_output != null && !var.hoop_community ? {
    for key, conn in module.mongoatlas_users.hoop_output.connections : key => merge(conn, {
      agent_id = module.mongoatlas_users.hoop_output.agent_id
      secrets = {
        "envvar:CONNECTION_STRING" = "_envs/gcp/${google_secret_manager_secret.atlas_conn_string[key].secret_id}"
      }
    })
  } : null
}

output "connection_string_secret_ids" {
  description = "Map of user keys to GCP Secret Manager secret IDs containing only the connection string. Use with hoop community edition by setting agent env vars and referencing via _envjson:ENV_VAR:<key>."
  value = {
    for k in keys(var.users) : k => google_secret_manager_secret.atlas_conn_string[k].id
  }
}
