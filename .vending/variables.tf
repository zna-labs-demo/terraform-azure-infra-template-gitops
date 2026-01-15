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
  description = "Azure Subscription ID"
  type        = string
}

# -----------------------------------------------------------------------------
# Environment Enablement (passed from pipeline via -var)
# -----------------------------------------------------------------------------
variable "dev_enabled" {
  description = "Whether DEV environment is enabled"
  type        = bool
  default     = false
}

variable "qa_enabled" {
  description = "Whether QA environment is enabled"
  type        = bool
  default     = false
}

variable "prod_enabled" {
  description = "Whether PROD environment is enabled"
  type        = bool
  default     = false
}
