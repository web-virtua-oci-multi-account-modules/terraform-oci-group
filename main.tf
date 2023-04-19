data "oci_identity_compartments" "compartment" {
  compartment_id = var.compartment_id
}

locals {
  tags_group = {
    "tf-name"        = var.name
    "tf-type"        = var.is_dynamic_group ? "dynamic-group" : "group"
    "tf-compartment" = "${data.oci_identity_compartments.compartment.name}"
  }
}

resource "oci_identity_group" "create_group" {
  count = !var.is_dynamic_group ? 1 : 0

  compartment_id = var.compartment_id
  name           = var.name
  description    = var.description
  defined_tags   = var.defined_tags
  freeform_tags  = merge(var.tags, var.use_tags_default ? local.tags_group : {})
}

resource "oci_identity_dynamic_group" "create_dynamic_group" {
  count = var.is_dynamic_group ? 1 : 0

  compartment_id = var.compartment_id
  name           = var.name
  description    = var.description
  matching_rule  = var.dynamic_matching_rule
  defined_tags   = var.defined_tags
  freeform_tags  = merge(var.tags, var.use_tags_default ? local.tags_group : {})
}

resource "oci_identity_policy" "create_policy" {
  for_each = { for index, policy in var.policies : index => policy }

  name           = each.value.name
  compartment_id = each.value.compartment_id
  description    = each.value.description
  statements     = each.value.statements
  version_date   = each.value.version_date
  defined_tags   = each.value.defined_tags

  freeform_tags = merge(each.value.freeform_tags, var.use_tags_default ? {
    "tf-name" = each.value.name
    "tf-type" = "policy"
  } : {})
}
