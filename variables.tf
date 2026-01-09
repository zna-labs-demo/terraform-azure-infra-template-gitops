# =============================================================================
# Input Variables
# =============================================================================
# Standard variables for infrastructure deployment.
# app_id is automatically populated by the subscription vending process.
# =============================================================================

variable "app_id" {
  description = "Application identifier from subscription vending (e.g., a2026010501)"
  type        = string

  validation {
    condition     = can(regex("^a[0-9]+$", var.app_id))
    error_message = "app_id must start with 'a' followed by numbers (e.g., a2026010501)."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, staging, prod."
  }
}

# =============================================================================
# ZNA Naming Components
# =============================================================================
# These variables support the ZNA naming standard:
# Pattern: [prefix][app-id][tier][instance][env][sequence]
# Example: a2026010501n1d01 -> App 2026010501, Non-Prod tier 1, Dev env, sequence 01
# =============================================================================

variable "tier" {
  description = "Tier identifier for ZNA naming (n = non-production, p = production)"
  type        = string
  default     = "n"

  validation {
    condition     = contains(["n", "p"], var.tier)
    error_message = "tier must be 'n' (non-production) or 'p' (production)."
  }
}

variable "environment_code" {
  description = "Environment code for ZNA naming (d = dev, q = qa, p = prod)"
  type        = string
  default     = "d"

  validation {
    condition     = contains(["d", "q", "p"], var.environment_code)
    error_message = "environment_code must be 'd' (dev), 'q' (qa), or 'p' (prod)."
  }
}

variable "sequence" {
  description = "Sequence number for ZNA naming (e.g., 01, 02)"
  type        = string
  default     = "01"

  validation {
    condition     = can(regex("^[0-9]{2}$", var.sequence))
    error_message = "sequence must be a 2-digit number (e.g., 01, 02)."
  }
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# =============================================================================
# Feature Flags
# =============================================================================
# Use these to enable/disable optional infrastructure components

variable "enable_storage_account" {
  description = "Create a storage account for the application"
  type        = bool
  default     = false
}

variable "enable_key_vault" {
  description = "Create a Key Vault for secrets management"
  type        = bool
  default     = false
}
