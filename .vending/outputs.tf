# =============================================================================
# Outputs - Environment Vending
# =============================================================================

output "enabled_environments" {
  description = "List of enabled environments"
  value       = keys(local.workspace_configs)
}

output "workspaces" {
  description = "Created TFC workspaces"
  value = {
    for name, ws in tfe_workspace.environment :
    name => {
      workspace_name  = ws.name
      workspace_id    = ws.id
      auto_apply      = ws.auto_apply
      subscription_id = local.workspace_configs[name].subscription_id
    }
  }
}

output "workspace_names" {
  description = "Map of environment to workspace name"
  value = {
    for name, config in local.workspace_configs :
    name => config.workspace_name
  }
}
