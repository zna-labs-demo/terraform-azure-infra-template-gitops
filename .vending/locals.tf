# =============================================================================
# Local Values - Environment Vending
# =============================================================================
# Uses var.dev_enabled, var.qa_enabled, var.prod_enabled from pipeline
# and environments.yaml for auto_approve settings
# =============================================================================

locals {
  # ---------------------------------------------------------------------------
  # Load and parse environment configuration (for auto_approve settings)
  # ---------------------------------------------------------------------------
  config = yamldecode(file("${path.module}/../environments.yaml"))

  # ---------------------------------------------------------------------------
  # Environment definitions with standard naming convention
  # Workspace naming: {app_id}{tier}1{env_code}{sequence}
  #   - DEV:  {app_id}n1d01
  #   - QA:   {app_id}n1q01
  #   - PROD: {app_id}p1p01
  # ---------------------------------------------------------------------------
  environment_definitions = {
    dev = {
      tier             = "n"
      environment_code = "d"
      sequence         = "01"
      auto_apply       = lookup(local.config.environments.dev, "auto_approve", true)
    }
    qa = {
      tier             = "n"
      environment_code = "q"
      sequence         = "01"
      auto_apply       = lookup(local.config.environments.qa, "auto_approve", false)
    }
    prod = {
      tier             = "p"
      environment_code = "p"
      sequence         = "01"
      auto_apply       = lookup(local.config.environments.prod, "auto_approve", false)
    }
  }

  # ---------------------------------------------------------------------------
  # Filter to only enabled environments (using var inputs from pipeline)
  # ---------------------------------------------------------------------------
  enabled_environments = {
    for name, env in local.environment_definitions :
    name => env
    if (name == "dev" && var.dev_enabled) ||
       (name == "qa" && var.qa_enabled) ||
       (name == "prod" && var.prod_enabled)
  }

  # ---------------------------------------------------------------------------
  # Generate workspace configurations
  # ---------------------------------------------------------------------------
  workspace_configs = {
    for name, env in local.enabled_environments :
    name => {
      # Workspace name: {app_id}{tier}1{env_code}{sequence}
      workspace_name   = "${var.app_id}${env.tier}1${env.environment_code}${env.sequence}"
      environment_name = name
      tier             = env.tier
      environment_code = env.environment_code
      sequence         = env.sequence
      auto_apply       = env.auto_apply

      # Calculate subnet CIDRs from app's VNet CIDR
      # App VNet: 10.X.0.0/16
      # Dev subnets: 10.X.0.0/24, 10.X.1.0/24, 10.X.2.0/26
      # QA subnets:  10.X.10.0/24, 10.X.11.0/24, 10.X.12.0/26
      # Prod subnets: 10.X.20.0/24, 10.X.21.0/24, 10.X.22.0/26
      subnet_offset = name == "dev" ? 0 : (name == "qa" ? 10 : 20)
    }
  }
}
