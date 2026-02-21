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
# Azure Credentials (passed through to environment workspaces)
# -----------------------------------------------------------------------------
variable "azure_client_id" {
  description = "Azure Service Principal Client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure Service Principal Client Secret"
  type        = string
  sensitive   = true
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
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
