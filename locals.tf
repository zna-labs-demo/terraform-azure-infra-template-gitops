# =============================================================================
# Local Values
# =============================================================================
# Computed values and naming conventions following ZNA standards.
# =============================================================================

locals {
  # Standard naming prefix: {app_id}-{environment}
  name_prefix = "${var.app_id}-${var.environment}"

  # Resource naming following Azure naming conventions
  resource_names = {
    resource_group  = "rg-${local.name_prefix}"
    storage_account = "st${replace(var.app_id, "-", "")}${var.environment}"
    key_vault       = "kv-${local.name_prefix}"
  }

  # Standard tags applied to all resources
  common_tags = merge(
    {
      app_id      = var.app_id
      environment = var.environment
      managed_by  = "terraform"
      provisioned = "subscription-vending"
      repository  = "terraform-azure-infra-${var.app_id}"
    },
    var.tags
  )
}
