# =============================================================================
# Terraform & Provider Versions - Environment Vending
# =============================================================================
# This terraform runs in the {app_id}-vending workspace and creates
# environment-specific workspaces based on environments.yaml
# =============================================================================

terraform {
  required_version = ">= 1.5.0"

  cloud {
    organization = "zna-labs"

    workspaces {
      tags = ["purpose:vending"]
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.57"
    }
  }
}
