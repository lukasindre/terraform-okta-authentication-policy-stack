output "authentication_policy_id" {
  value       = okta_app_signon_policy.this.id
  description = "The ID of the authentication policy."
}

output "authentication_policy_rules" {
  value       = var.rules
  description = "The IDs of the authentication policy rules."
}

output "network_zones" {
  value       = local.network_zones
  description = "The network zones associated with the authentication policy."
}