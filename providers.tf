# =============================================================================
# Provider Configuration
# =============================================================================
# This file configures the required providers for Azure infrastructure deployment.
# The Azure subscription is automatically configured via TFC workspace variables.
#
# WORKSPACE SELECTION:
# The CI/CD pipeline automatically sets TF_WORKSPACE environment variable to
# select the correct workspace for each environment:
#   - Dev:  {app_id}n1d01-app-infra
#   - QA:   {app_id}n1q01-app-infra
#   - Prod: {app_id}p1p01-app-infra
#
# For local development, set TF_WORKSPACE before running terraform commands:
#   export TF_WORKSPACE="{app_id}n1d01-app-infra"
#   terraform init
# =============================================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Terraform Cloud workspace configuration
  # Workspaces are created by the subscription vending process (3 per app)
  # TF_WORKSPACE environment variable overrides the tag selection in CI/CD
  cloud {
    organization = "zna-labs"

    workspaces {
      tags = ["managed-by:subscription-vending"]
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  # Subscription ID is injected via TFC workspace environment variable
  # ARM_SUBSCRIPTION_ID is set automatically by the vending process
}
