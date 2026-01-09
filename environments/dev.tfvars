# =============================================================================
# DEVELOPMENT ENVIRONMENT CONFIGURATION
# =============================================================================
# This file contains environment-specific values for the DEV environment.
#
# NOTE: app_id is passed from the pipeline variable, not set here.
# =============================================================================

# -----------------------------------------------------------------------------
# ZNA Naming Components
# -----------------------------------------------------------------------------
# Pattern: [prefix][app-id][tier][instance][env][sequence]
# Example: a2026010501n1d01 -> App 2026010501, Non-Prod tier 1, Dev env, sequence 01
tier             = "n"  # n = non-production
environment_code = "d"  # d = development
sequence         = "01"

# -----------------------------------------------------------------------------
# Environment Settings
# -----------------------------------------------------------------------------
environment = "dev"
location    = "eastus"

# -----------------------------------------------------------------------------
# Feature Flags
# -----------------------------------------------------------------------------
# Dev environment - enable for development/testing
enable_storage_account = false
enable_key_vault       = false

# -----------------------------------------------------------------------------
# Additional Tags (optional)
# -----------------------------------------------------------------------------
tags = {
  CostCenter = "development"
}
