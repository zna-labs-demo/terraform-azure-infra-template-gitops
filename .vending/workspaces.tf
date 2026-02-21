# =============================================================================
# TFC Workspaces - Environment Vending
# =============================================================================
# Creates TFC workspaces for each enabled environment in environments.yaml
# This is the heart of the GitOps approach - teams control which environments
# exist by editing environments.yaml
# =============================================================================

resource "tfe_workspace" "environment" {
  for_each = local.workspace_configs

  name         = each.value.workspace_name
  organization = var.tfc_org
  description  = "Infrastructure for ${var.app_id} - ${upper(each.value.environment_name)} - Owner: ${var.owner_email}"

  # CLI-driven - ADO pipeline triggers runs
  execution_mode    = "remote"
  auto_apply        = each.value.auto_apply
  queue_all_runs    = false
  working_directory = "" # Root of repo (infrastructure is in main.tf, etc.)
  force_delete      = true

  tag_names = [
    "app:${var.app_id}",
    "env:${each.value.environment_name}",
    "tier:${each.value.tier}",
    "cost-center:${lower(replace(var.cost_center, "-", ""))}",
    "owner:${lower(replace(replace(var.owner_email, "@", "-at-"), ".", "-"))}",
    "managed-by:gitops-vending"
  ]
}

# =============================================================================
# Attach Azure OIDC Variable Set to each environment workspace
# =============================================================================
# The variable set (created by Phase 1) provides:
# - TFC_AZURE_PROVIDER_AUTH = true
# - TFC_AZURE_RUN_CLIENT_ID = {app-specific client ID}
# - ARM_TENANT_ID
# - ARM_SUBSCRIPTION_ID (default; overridden per-environment below)
# =============================================================================

resource "tfe_workspace_variable_set" "azure_oidc" {
  for_each = local.workspace_configs

  workspace_id    = tfe_workspace.environment[each.key].id
  variable_set_id = var.azure_oidc_variable_set_id
}

# =============================================================================
# Per-Environment Subscription ID Override
# =============================================================================
# Workspace variables override variable set values, so this per-environment
# subscription_id takes precedence over the default in the OIDC variable set.
# =============================================================================

resource "tfe_variable" "arm_subscription_id" {
  for_each = local.workspace_configs

  key          = "ARM_SUBSCRIPTION_ID"
  value        = each.value.subscription_id != "" ? each.value.subscription_id : var.azure_subscription_id
  category     = "env"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Azure Subscription ID (per-environment from central vending)"
}

# =============================================================================
# Workspace Variables - Terraform Variables
# =============================================================================

resource "tfe_variable" "app_id" {
  for_each = local.workspace_configs

  key          = "app_id"
  value        = var.app_id
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Application ID"
}

resource "tfe_variable" "environment" {
  for_each = local.workspace_configs

  key          = "environment"
  value        = each.value.environment_name
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Environment name (dev/qa/test/prod)"
}

resource "tfe_variable" "tier" {
  for_each = local.workspace_configs

  key          = "tier"
  value        = each.value.tier
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Tier (n=non-prod, p=prod)"
}

resource "tfe_variable" "environment_code" {
  for_each = local.workspace_configs

  key          = "environment_code"
  value        = each.value.environment_code
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Environment code (d=dev, q=qa, t=test, p=prod)"
}

resource "tfe_variable" "sequence" {
  for_each = local.workspace_configs

  key          = "sequence"
  value        = each.value.sequence
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Sequence number"
}

resource "tfe_variable" "vnet_cidr" {
  for_each = local.workspace_configs

  key          = "vnet_cidr"
  value        = var.vnet_cidr
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "VNet CIDR block allocated to this application"
}

resource "tfe_variable" "subnet_offset" {
  for_each = local.workspace_configs

  key          = "subnet_offset"
  value        = tostring(each.value.subnet_offset)
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Subnet offset within VNet for this environment"
}

resource "tfe_variable" "owner_email" {
  for_each = local.workspace_configs

  key          = "owner_email"
  value        = var.owner_email
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Application owner email"
}

resource "tfe_variable" "cost_center" {
  for_each = local.workspace_configs

  key          = "cost_center"
  value        = var.cost_center
  category     = "terraform"
  workspace_id = tfe_workspace.environment[each.key].id
  description  = "Cost center code"
}
