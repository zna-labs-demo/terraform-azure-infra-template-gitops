# =============================================================================
# Local Values - Environment Vending
# =============================================================================
# Matches the environments array (from central vending via TF_VAR_environments)
# against environments.yaml (in-repo enablement) to determine which
# environment workspaces to create.
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Load and parse environment configuration (for enabled + auto_approve)
  # ---------------------------------------------------------------------------
  config = yamldecode(file("${path.module}/../environments.yaml"))

  # ---------------------------------------------------------------------------
  # Map sub_environment prefix letter to environment name
  # ---------------------------------------------------------------------------
  sub_env_to_name = {
    "d" = "dev"
    "q" = "qa"
    "t" = "test"
    "p" = "prod"
  }

  # ---------------------------------------------------------------------------
  # Convert environments array to map keyed by environment name
  # ---------------------------------------------------------------------------
  env_configs = {
    for env in var.environments :
    local.sub_env_to_name[substr(env.sub_environment, 0, 1)] => {
      environment     = env.environment
      sub_environment = env.sub_environment
      subscription_id = env.subscription_id
      tier_letter     = substr(env.environment, 0, 1)
      env_code_letter = substr(env.sub_environment, 0, 1)
      sequence        = substr(env.sub_environment, 1, 2)
    }
  }

  # ---------------------------------------------------------------------------
  # Filter to only enabled environments (from environments.yaml)
  # ---------------------------------------------------------------------------
  enabled_environments = {
    for name, env in local.env_configs :
    name => env
    if lookup(lookup(local.config.environments, name, {}), "enabled", false)
  }

  # ---------------------------------------------------------------------------
  # Generate workspace configurations
  # ---------------------------------------------------------------------------
  workspace_configs = {
    for name, env in local.enabled_environments :
    name => {
      # Workspace name: {app_id}{environment}{sub_environment}
      workspace_name   = "${var.app_id}${env.environment}${env.sub_environment}"
      environment_name = name
      tier             = env.tier_letter
      environment_code = env.env_code_letter
      sequence         = env.sequence
      subscription_id  = env.subscription_id
      auto_apply       = lookup(lookup(local.config.environments, name, {}), "auto_approve", name == "dev")

      # Calculate subnet CIDRs from app's VNet CIDR
      subnet_offset = name == "dev" ? 0 : (name == "qa" ? 10 : (name == "test" ? 15 : 20))
    }
  }
}
