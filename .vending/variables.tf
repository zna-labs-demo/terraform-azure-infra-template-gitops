# =============================================================================
# Input Variables - Environment Vending
# =============================================================================
# These variables are set by central vending on the {app_id}-vending workspace
# via TF_VAR_* environment variables
# =============================================================================

variable "tfc_org" {
  description = "Terraform Cloud organization name"
  type        = string
}

variable "app_id" {
  description = "Application ID (e.g., a2026011201)"
  type        = string
}

variable "owner_email" {
  description = "Application owner email"
  type        = string
}

variable "cost_center" {
  description = "Cost center code"
  type        = string
}

variable "vnet_cidr" {
  description = "Allocated VNet CIDR block for this application"
  type        = string
}

# -----------------------------------------------------------------------------
# Azure OIDC (passed through from Phase 1 variable set)
# -----------------------------------------------------------------------------
variable "azure_oidc_variable_set_id" {
  description = "TFC Variable Set ID containing Azure OIDC credentials for this app"
  type        = string
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID (fallback default; per-environment values come from the environments array)"
  type        = string
}

# -----------------------------------------------------------------------------
# Environment Configurations (set by central vending from main.apps.json)
# -----------------------------------------------------------------------------
variable "environments" {
  description = "List of environment configurations from central vending (environment tier, sub_environment code, and subscription_id)"
  type = list(object({
    environment     = string
    sub_environment = string
    subscription_id = string
  }))
  default = []
}
