variable "tenant_root_group_id" {
  description = "Azure AD Tenant Root Management Group ID"
  type        = string
}
variable "primary_location" {
  description = "Primary Azure region"
  type        = string
  default     = "eastus2"
}
variable "connectivity_subscription_id" {
  description = "Subscription ID for Hub/Connectivity resources"
  type        = string
  sensitive   = true
}
variable "management_subscription_id" {
  description = "Subscription ID for Management/Monitoring"
  type        = string
  sensitive   = true
}
variable "hub_vnet_cidr" {
  description = "CIDR block for Hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}
variable "enable_express_route" {
  description = "Deploy ExpressRoute Gateway"
  type        = bool
  default     = false
}
variable "spoke_configs" {
  description = "Map of spoke VNet configurations"
  type = map(object({
    cidr            = string
    subscription_id = string
    environment     = string
  }))
}
variable "private_dns_zones" {
  description = "List of Private DNS Zones to create in Hub"
  type        = list(string)
  default = [
    "privatelink.blob.core.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.database.windows.net",
    "privatelink.azurecr.io"
  ]
}
variable "alerts_email" {
  description = "Email for Azure Monitor alerts"
  type        = string
  sensitive   = true
}