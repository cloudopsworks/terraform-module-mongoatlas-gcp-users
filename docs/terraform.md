## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 7.0 |
| <a name="requirement_mongodbatlas"></a> [mongodbatlas](#requirement\_mongodbatlas) | ~> 2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.4 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 7.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_mongoatlas_users"></a> [mongoatlas\_users](#module\_mongoatlas\_users) | git::https://github.com/cloudopsworks/terraform-module-mongoatlas-users.git | v1.4.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [google_secret_manager_secret.atlas_conn_string](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret.atlas_cred](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_version.atlas_conn_string](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_secret_manager_secret_version.atlas_cred](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_project.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_force_reset"></a> [force\_reset](#input\_force\_reset) | force\_reset: false # (Optional) Force-reset credentials (break-glass). Default: false. | `bool` | `false` | no |
| <a name="input_hoop"></a> [hoop](#input\_hoop) | hoop:<br/>  enabled: false # (Optional) Enable Hoop.dev connection output. Default: false.<br/>  community: true # (Optional) When true, use community/open-source agent format. Community does not support GCP Secret Manager as agent-side provider; hoop\_connections will be null. Use enterprise for \_envs/gcp/ support. Default: true.<br/>  agent\_id: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # (Required if enabled) Hoop agent UUID. No default.<br/>  tags: # (Optional) Tags for the Hoop connection. Default: {}.<br/>    key: "value"<br/>  access\_control: [] # (Optional) Global access control list. Default: []. | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_kms_key_name"></a> [kms\_key\_name](#input\_kms\_key\_name) | kms\_key\_name: "" # (Optional) Google Cloud KMS key name for CMEK encryption of Secret Manager secrets. Format: "projects/PROJECT/locations/LOCATION/keyRings/RING/cryptoKeys/KEY". Default: null (Google-managed encryption). | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | name\_prefix: "atlas" # (Required) Prefix used to compose usernames when `users[<key>].username` is not provided. Allowed: lowercase letters, numbers, and hyphens. No default. | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_password_rotation_period"></a> [password\_rotation\_period](#input\_password\_rotation\_period) | password\_rotation\_period: 90 # (Optional) Default rotation period in days. Overridden by users[*].password\_rotation\_period. Allowed: 1-365. Default: 90. | `number` | `90` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | project\_id: "60f0f0f0f0f0f0f0f0f0f0f0" # (Optional) Atlas Project ID. One of `project_id` or `project_name` must be provided. Default: "". | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | project\_name: "my-project" # (Optional) Atlas Project Name. One of `project_id` or `project_name` must be provided. Default: "". | `string` | `""` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |
| <a name="input_users"></a> [users](#input\_users) | users:<br/>  <user\_key>:<br/>    username: "user1" # (Optional) Explicit username. If omitted, composed as `<name_prefix|user.name_prefix>-<system_name_short>-<user_key>`. Default: generated.<br/>    name\_prefix: "prefix1" # (Optional) Per-user prefix. Defaults to var.name\_prefix. Default: null.<br/>    auth\_database: "admin" # (Optional) Authentication database. Default: "admin".<br/>    password\_rotation\_period: 90 # (Optional) Rotation period in days. Overrides var.password\_rotation\_period. Default: var.password\_rotation\_period.<br/>    import: false # (Optional) When true, imports existing Atlas user. Default: false.<br/>    role\_name: "readwrite" # (Optional) Role key for Hoop naming. Allowed: readwrite, read, dbadmin, admin, dbowner, owner, clusteradmin. Default: "default".<br/>    roles: # (Required) MongoDB roles granted to this user.<br/>      - role\_name: "readWrite" # (Required) Built-in or custom role. No default.<br/>        database\_name: "test" # (Required) Target database. No default.<br/>        collection\_name: "widgets" # (Optional) Collection scope. Default: null.<br/>    scopes: # (Optional) Atlas scope bindings.<br/>      - name: "cluster-name" # (Required) Cluster or data lake name. No default.<br/>        type: "CLUSTER" # (Optional) Allowed: CLUSTER, DATA\_LAKE. Default: "CLUSTER".<br/>    connection\_strings: # (Optional) Connection string generation config.<br/>      enabled: false # (Optional) When true, include connection strings. Default: false.<br/>      cluster: "cluster0" # (Required if enabled) Atlas Cluster name. No default.<br/>      endpoint\_id: "" # (Optional) Private endpoint ID. Default: "".<br/>      database\_name: "" # (Optional) Database name for URI. Default: "".<br/>    hoop: # (Optional) Per-user Hoop.dev overrides.<br/>      import: false # (Optional) Import existing Hoop connection. Default: false.<br/>      access\_control: [] # (Optional) Per-user access control merged with global. Default: []. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_connection_string_secret_ids"></a> [connection\_string\_secret\_ids](#output\_connection\_string\_secret\_ids) | Map of user keys to GCP Secret Manager secret IDs containing only the connection string. Use with hoop community edition by setting agent env vars and referencing via \_envjson:ENV\_VAR:<key>. |
| <a name="output_hoop_connections"></a> [hoop\_connections](#output\_hoop\_connections) | Hoop connection definitions enriched with GCP Secret Manager secret references. Pass as the `connections` input to terraform-module-hoop-connection. Community mode returns null (no \_gcp agent provider); enterprise mode uses \_envs/gcp/<secret-id>. |
| <a name="output_users"></a> [users](#output\_users) | User metadata map enriched with the GCP Secret Manager secret ID for each user's credentials. |
