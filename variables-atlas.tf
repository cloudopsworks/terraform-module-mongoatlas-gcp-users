##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "name_prefix" {
  description = <<-EOD
  name_prefix: "atlas" # (Required) Prefix used to compose usernames when `users[<key>].username` is not provided. Allowed: lowercase letters, numbers, and hyphens. No default.
  EOD
  type        = string
}

variable "project_id" {
  description = <<-EOD
  project_id: "60f0f0f0f0f0f0f0f0f0f0f0" # (Optional) Atlas Project ID. One of `project_id` or `project_name` must be provided. Default: "".
  EOD
  type        = string
  default     = ""
}

variable "project_name" {
  description = <<-EOD
  project_name: "my-project" # (Optional) Atlas Project Name. One of `project_id` or `project_name` must be provided. Default: "".
  EOD
  type        = string
  default     = ""
}

variable "users" {
  description = <<-EOD
  users:
    <user_key>:
      username: "user1" # (Optional) Explicit username. If omitted, composed as `<name_prefix|user.name_prefix>-<system_name_short>-<user_key>`. Default: generated.
      name_prefix: "prefix1" # (Optional) Per-user prefix. Defaults to var.name_prefix. Default: null.
      auth_database: "admin" # (Optional) Authentication database. Default: "admin".
      password_rotation_period: 90 # (Optional) Rotation period in days. Overrides var.password_rotation_period. Default: var.password_rotation_period.
      import: false # (Optional) When true, imports existing Atlas user. Default: false.
      role_name: "readwrite" # (Optional) Role key for Hoop naming. Allowed: readwrite, read, dbadmin, admin, dbowner, owner, clusteradmin. Default: "default".
      roles: # (Required) MongoDB roles granted to this user.
        - role_name: "readWrite" # (Required) Built-in or custom role. No default.
          database_name: "test" # (Required) Target database. No default.
          collection_name: "widgets" # (Optional) Collection scope. Default: null.
      scopes: # (Optional) Atlas scope bindings.
        - name: "cluster-name" # (Required) Cluster or data lake name. No default.
          type: "CLUSTER" # (Optional) Allowed: CLUSTER, DATA_LAKE. Default: "CLUSTER".
      connection_strings: # (Optional) Connection string generation config.
        enabled: false # (Optional) When true, include connection strings. Default: false.
        cluster: "cluster0" # (Required if enabled) Atlas Cluster name. No default.
        endpoint_id: "" # (Optional) Private endpoint ID. Default: "".
        database_name: "" # (Optional) Database name for URI. Default: "".
      hoop: # (Optional) Per-user Hoop.dev overrides.
        import: false # (Optional) Import existing Hoop connection. Default: false.
        access_control: [] # (Optional) Per-user access control merged with global. Default: [].
  EOD
  type        = any
  default     = {}
}

variable "hoop" {
  description = <<-EOD
  hoop:
    enabled: false # (Optional) Enable Hoop.dev connection output. Default: false.
    agent_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # (Required if enabled) Hoop agent UUID. No default.
    tags: # (Optional) Tags for the Hoop connection. Default: {}.
      key: "value"
    access_control: [] # (Optional) Global access control list. Default: [].
  EOD
  type        = any
  default     = {}
}

variable "password_rotation_period" {
  description = <<-EOD
  password_rotation_period: 90 # (Optional) Default rotation period in days. Overridden by users[*].password_rotation_period. Allowed: 1-365. Default: 90.
  EOD
  type        = number
  default     = 90
  nullable    = false
}

variable "force_reset" {
  description = <<-EOD
  force_reset: false # (Optional) Force-reset credentials (break-glass). Default: false.
  EOD
  type        = bool
  default     = false
}

variable "kms_key_name" {
  description = <<-EOD
  kms_key_name: "" # (Optional) Google Cloud KMS key name for CMEK encryption of Secret Manager secrets. Format: "projects/PROJECT/locations/LOCATION/keyRings/RING/cryptoKeys/KEY". Default: null (Google-managed encryption).
  EOD
  type        = string
  default     = null
}

variable "hoop_community" {
  description = <<-EOD
  hoop_community: true # (Optional) When true, use hoop community/open-source agent format. Community does not support GCP Secret Manager as an agent-side secret provider; hoop_connections output will be null. Use enterprise/managed version for _envs/gcp/ support, or configure agent env vars manually with _envjson. Default: true.
  EOD
  type        = bool
  default     = true
  nullable    = false
}
