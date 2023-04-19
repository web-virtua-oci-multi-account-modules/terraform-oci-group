# OCI Group with Policies for multiples accounts with Terraform module
* This module simplifies creating and configuring of Group with Policies across multiple accounts on OCI

* Is possible use this module with one account using the standard profile or multi account using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Criate file provider.tf with the exemple code below:
```hcl
provider "oci" {
  alias   = "alias_profile_a"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.ssh_private_key_path
  region           = var.region
}

provider "oci" {
  alias   = "alias_profile_b"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.ssh_private_key_path
  region           = var.region
}
```


## Features enable of Group configurations for this module:

- Identity group
- Identity user group membership
- Identity dynamic group
- Identity Policy

## Usage exemples


### Create group without policy

```hcl
module "main_clients_compartment" {
  source = "web-virtua-oci-multi-account-modules/group/oci"

  compartment_id = var.tenancy_ocid
  name           = "tf-access"
  description    = "Access group"

  providers = {
    oci = oci.alias_profile_a
  }
}
```

### Create group without policy and attaching users

```hcl
module "main_clients_compartment" {
  source = "web-virtua-oci-multi-account-modules/group/oci"

  compartment_id = var.tenancy_ocid
  name           = "tf-access"
  description    = "Access group"

  group_users_ids = [
    var.user_ocid_1,
    var.user_ocid_2
  ]

  providers = {
    oci = oci.alias_profile_a
  }
}
```

### Create dynamic group without policy

```hcl
module "main_clients_compartment" {
  source = "web-virtua-oci-multi-account-modules/group/oci"

  compartment_id        = var.tenancy_ocid
  name                  = "tf-dynamic-access-main-clientes"
  is_dynamic_group      = true
  description           = "Dynamic access main clientes group"
  dynamic_matching_rule = "All {instance.compartment.id = '${var.tenancy_ocid}'}"

  providers = {
    oci = oci.alias_profile_a
  }
}
```

### Create group with policy

```hcl
module "main_clients_compartment" {
  source = "web-virtua-oci-multi-account-modules/group/oci"

  compartment_id = var.tenancy_ocid
  name           = "tf-access"
  description    = "Access group"

  policies = [
    {
        name           = "tf-oke-scanning-image-policy"
        compartment_id = var.compatment_id
        description    = "Description"
        statements     = [
            "Allow service vulnerability-scanning-service to read repos in tenancy"
        ]
    }
  ]

  providers = {
    oci = oci.alias_profile_b
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name | `string` | `-` | yes | Compartment name | `-` |
| description | `string` | `-` | yes | Description to compartment is required | `-` |
| is_dynamic_group | `bool` | `false` | no | If true will be create as dynamic group, else will be create as group | `*`false <br> `*`true |
| compartment_id | `string` | `null` | no | Compartment ID | `-` |
| group_users_ids | `list(string)` | `[]` | no | List with OCID of user to attach in group | `-` |
| enable_delete | `bool` | `true` | no | If true allow delete the compartiment | `*`false <br> `*`true |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to resources | `*`false <br> `*`true |
| dynamic_matching_rule | `string` | `null` | no | Matching rule | `-` |
| tags | `map(any)` | `{}` | no | Tags to compartment | `-` |
| defined_tags | `map(any)` | `{}` | no | Defined tags to compartment | `-` |
| policies | `list(object)` | `[]` | no | List of policies to be created | `-` |

* Model of variable policies
```hcl
variable "policies" {
  description = "List of policies to be created"
  type = list(object({
    name           = string
    compartment_id = string
    description    = string
    statements     = list(string)
    version_date   = optional(string)
    defined_tags   = optional(map(any))
    freeform_tags  = optional(map(any))
  }))
  default = [
    {
        name           = "tf-oke-scanning-image-policy"
        compartment_id = "ocid1.tenancy.oc1..aaaaa...wfgjhgfjhgfjhg"
        description    = "Enable policy to scan all vulnerability on services in tenancy OCIR"
        statements     = [
            "Allow service vulnerability-scanning-service to read repos in tenancy"
        ]
    }
  ]
}
```


## Resources

| Name | Type |
|------|------|
| [oci_identity_group.create_group](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_group) | resource |
| [oci_identity_user_group_membership.create_attachment_user_on_group](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_user_group_membership) | resource |
| [oci_identity_dynamic_group.create_dynamic_group](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_dynamic_group) | resource |
| [oci_identity_policy.create_policy](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartments) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `group` | Group |
| `group_id` | Group ID |
| `group_attachments` | Group attachments |
| `dynamic_group` | Dynamic group |
| `dynamic_group_id` | Dynamic group ID |
| `policies` | Policies |
