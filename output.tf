output "group" {
  description = "Group"
  value       = try(oci_identity_group.create_group[0], null)
}

output "group_id" {
  description = "Group ID"
  value       = try(oci_identity_group.create_group[0].id, null)
}

output "group_attachments" {
  description = "Group attachments"
  value       = try(oci_identity_user_group_membership.create_attachment_user_on_group, null)
}

output "dynamic_group" {
  description = "Dynamic group"
  value       = try(oci_identity_dynamic_group.create_dynamic_group[0], null)
}

output "dynamic_group_id" {
  description = "Dynamic group ID"
  value       = try(oci_identity_dynamic_group.create_dynamic_group[0].id, null)
}

output "policies" {
  description = "Policies"
  value       = try(oci_identity_policy.create_policy, null)
}
