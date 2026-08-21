variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "ddos_network_protection_plan_name" {
  type = string
}

variable "application_vnet_name" {
  type = string
}

variable "application_vnet_address_space" {
  type = list(string)
}

variable "app_gateway_subnet_name" {
  type = string
}

variable "app_gateway_subnet_prefixes" {
  type = list(string)
}

variable "app_service_subnet_name" {
  type = string
}

variable "app_service_subnet_prefixes" {
  type = list(string)
}

variable "private_endpoints_subnet_name" {
  type = string
}

variable "private_endpoints_subnet_prefixes" {
  type = list(string)
}

variable "deployment_vnet_name" {
  type = string
}

variable "deployment_vnet_address_space" {
  type = list(string)
}

variable "deployment_bastion_subnet_name" {
  type = string
}

variable "deployment_bastion_subnet_prefixes" {
  type = list(string)
}

variable "deployment_agent_subnet_name" {
  type = string
}

variable "deployment_agent_subnet_prefixes" {
  type = list(string)
}

variable "enable_ddos_network_protection" {
  description = "Whether the paid Azure DDoS Network Protection plan is created and associated with the VNets."
  type        = bool
}
