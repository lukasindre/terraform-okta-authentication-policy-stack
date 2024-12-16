output "authentication_policy_id" {
  value       = okta_app_signon_policy.this.id
  description = "The ID of the authentication policy."
}

output "network_zones" {
  value       = local.network_zones
  description = "The network zones."
}

output "groups" {
  value       = local.groups
  description = "The groups."
}