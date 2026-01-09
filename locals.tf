# =============================================================================
# Local Values
# =============================================================================
# Computed values and naming conventions following ZNA standards.
# =============================================================================

locals {
  # Standard naming prefix: {app_id}-{environment}
  name_prefix = "${var.app_id}-${var.environment}"

  # ZNA naming pattern: [prefix][app-id][tier][instance][env][sequence]
  # Example: a2026010501n1d01 -> App 2026010501, Non-Prod tier 1, Dev env, sequence 01
  zna_prefix = "${var.app_id}${var.tier}1${var.environment_code}${var.sequence}"

  # Resource naming following Azure naming conventions
  resource_names = {
    resource_group  = "rg-${local.name_prefix}"
    storage_account = "st${replace(var.app_id, "-", "")}${var.environment}"
    key_vault       = "kv-${local.name_prefix}"
  }

  # Standard tags applied to all resources
  common_tags = merge(
    {
      app_id           = var.app_id
      environment      = var.environment
      environment_code = var.environment_code
      tier             = var.tier
      zna_prefix       = local.zna_prefix
      managed_by       = "terraform"
      provisioned      = "subscription-vending"
      repository       = "terraform-azure-infra-${var.app_id}"
    },
    var.tags
  )
}
