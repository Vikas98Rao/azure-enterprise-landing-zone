# Azure Enterprise Landing Zone - Root Module
# Author: Vikas Rao | Senior DevOps Engineer

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-management"
    storage_account_name = "stgtfstatelz001"
    container_name       = "tfstate"
    key                  = "landing-zone/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group { prevent_deletion_if_contains_resources = true }
    key_vault      { purge_soft_delete_on_destroy = false }
  }
}

module "management_groups" {
  source               = "./modules/management-groups"
  tenant_root_group_id = var.tenant_root_group_id
  management_groups    = var.management_groups
}

module "hub_network" {
  source              = "./modules/hub-network"
  location            = var.primary_location
  subscription_id     = var.connectivity_subscription_id
  hub_vnet_cidr       = var.hub_vnet_cidr
  firewall_sku        = "Premium"
  enable_vpn_gateway  = true
  enable_er_gateway   = var.enable_express_route
  private_dns_zones   = var.private_dns_zones
  depends_on          = [module.management_groups]
}

module "policy_assignments" {
  source                   = "./modules/policy"
  management_group_id      = module.management_groups.root_mg_id
  enable_cis_benchmark     = true
  enable_mcsb              = true
  enable_defender_plans    = true
  log_analytics_workspace  = module.monitoring.workspace_id
  depends_on               = [module.management_groups]
}

module "monitoring" {
  source               = "./modules/monitoring"
  location             = var.primary_location
  subscription_id      = var.management_subscription_id
  retention_days       = 90
  enable_sentinel      = true
  action_group_email   = var.alerts_email
}