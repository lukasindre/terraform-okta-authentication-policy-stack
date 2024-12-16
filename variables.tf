variable "name" {
  description = "Name of the policy."
  type        = string
}

variable "description" {
  description = "Description of the policy."
  type        = string
}

variable "rules" {
  description = "List of configured rules"
  type = list(object({
    name               = string
    access             = string
    network_zones      = optional(list(string), [])
    step_up_auth       = optional(bool, false)
    auth_frequency     = optional(string)
    group_targets      = optional(list(string), [])
    group_exclusions   = optional(list(string), [])
    managed_device     = optional(list(string), [])
    unmanaged_device   = optional(list(string), [])
    phishing_resistant = optional(bool, true)
  }))
}