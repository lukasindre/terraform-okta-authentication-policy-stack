output "authentication_policy_id" {
  value       = okta_app_signon_policy.this.id
  description = "The ID of the authentication policy."
}