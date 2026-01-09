# =============================================================================
# QA ENVIRONMENT CONFIGURATION
# =============================================================================
# This file contains environment-specific values for the QA environment.
#
# NOTE: app_id is passed from the pipeline variable, not set here.
# =============================================================================

# -----------------------------------------------------------------------------
# ZNA Naming Components
# -----------------------------------------------------------------------------
# Pattern: [prefix][app-id][tier][instance][env][sequence]
# Example: a2026010501n1q01 -> App 2026010501, Non-Prod tier 1, QA env, sequence 01
tier             = "n"  # n = non-production
environment_code = "q"  # q = QA
sequence         = "01"

# -----------------------------------------------------------------------------
# Environment Settings
# -----------------------------------------------------------------------------
environment = "staging"  # Using staging as the closest to QA in the validation
location    = "eastus"

# -----------------------------------------------------------------------------
# Feature Flags
# -----------------------------------------------------------------------------
# QA environment - mirror production settings for testing
enable_storage_account = false
enable_key_vault       = false

# -----------------------------------------------------------------------------
# Additional Tags (optional)
# -----------------------------------------------------------------------------
tags = {
  CostCenter = "testing"
}
