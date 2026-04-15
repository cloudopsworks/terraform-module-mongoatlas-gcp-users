##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works/
#     Distributed Under Apache v2.0 License
#

locals {
  secret_ids = {
    for k in keys(var.users) : k => format("%s/mongodbatlas/%s/%s",
      local.secret_store_path,
      lower(replace(replace(module.mongoatlas_users.users[k].project_name, " ", ""), "_", "-")),
      lower(replace(k, "_", "-")),
    )
  }
}

resource "google_secret_manager_secret" "atlas_cred" {
  for_each  = var.users
  secret_id = lower(replace(local.secret_ids[each.key], "/[^a-zA-Z0-9_-]/", "-"))

  labels = merge(local.all_tags, {
    "mongodb-username" = module.mongoatlas_users.users[each.key].username
    "mongodb-project"  = module.mongoatlas_users.users[each.key].project_name
    },
    try(var.users[each.key].connection_strings.database_name, "") != "" ? { "mongodb-dbname" = try(var.users[each.key].connection_strings.database_name, "") } : {}
  )

  replication {
    auto {
      dynamic "customer_managed_encryption" {
        for_each = var.kms_key_name != null ? [1] : []
        content {
          kms_key_name = var.kms_key_name
        }
      }
    }
  }

  depends_on = [module.mongoatlas_users]
}

resource "google_secret_manager_secret_version" "atlas_cred" {
  for_each    = var.users
  secret      = google_secret_manager_secret.atlas_cred[each.key].id
  secret_data = jsonencode(module.mongoatlas_users.credentials[each.key])

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_secret_manager_secret" "atlas_conn_string" {
  for_each  = var.users
  secret_id = lower(replace("${local.secret_ids[each.key]}-conn-string", "/[^a-zA-Z0-9_-]/", "-"))

  labels = merge(local.all_tags, {
    "mongodb-username" = module.mongoatlas_users.users[each.key].username
    "mongodb-project"  = module.mongoatlas_users.users[each.key].project_name
    },
    try(var.users[each.key].connection_strings.database_name, "") != "" ? { "mongodb-dbname" = try(var.users[each.key].connection_strings.database_name, "") } : {}
  )

  replication {
    auto {
      dynamic "customer_managed_encryption" {
        for_each = var.kms_key_name != null ? [1] : []
        content {
          kms_key_name = var.kms_key_name
        }
      }
    }
  }

  depends_on = [module.mongoatlas_users]
}

resource "google_secret_manager_secret_version" "atlas_conn_string" {
  for_each    = var.users
  secret      = google_secret_manager_secret.atlas_conn_string[each.key].id
  secret_data = module.mongoatlas_users.credentials[each.key].connection_string

  lifecycle {
    create_before_destroy = true
  }
}
