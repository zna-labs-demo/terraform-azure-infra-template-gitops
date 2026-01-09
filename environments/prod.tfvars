# =============================================================================
# PRODUCTION ENVIRONMENT CONFIGURATION
# =============================================================================
# This file contains environment-specific values for the PROD environment.
#
# NOTE: app_id is passed from the pipeline variable, not set here.
# IMPORTANT: Production changes require approval in the Azure DevOps pipeline.
# =============================================================================

# -----------------------------------------------------------------------------
# ZNA Naming Components
# -----------------------------------------------------------------------------
# Pattern: [prefix][app-id][tier][instance][env][sequence]
# Example: a2026010501p1p01 -> App 2026010501, Prod tier 1, Prod env, sequence 01
tier             = "p"  # p = production
environment_code = "p"  # p = production
sequence         = "01"

# -----------------------------------------------------------------------------
# Environment Settings
# -----------------------------------------------------------------------------
environment = "prod"
location    = "eastus"

# -----------------------------------------------------------------------------
# Feature Flags
# -----------------------------------------------------------------------------
# Production environment - enable required services
enable_storage_account = false
enable_key_vault       = false

# -----------------------------------------------------------------------------
# Additional Tags (optional)
# -----------------------------------------------------------------------------
tags = {
  CostCenter  = "production"
  Criticality = "high"
}
