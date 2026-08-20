############################################################
# Edge Gateway names
############################################################

locals {
  application_gateway_public_ip_name = "pip-appgw-${var.name_prefix}"
  waf_policy_name                    = "wafpol-${var.name_prefix}"
  application_gateway_name           = "agw-${var.name_prefix}"
}

############################################################
# Application Gateway Public IP
############################################################

resource "azurerm_public_ip" "application_gateway" {
  name                = local.application_gateway_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = ["1", "2", "3"]
  idle_timeout_in_minutes = 4

  # Protection is inherited from the DDoS plan assigned
  # to the Application VNet.
  ddos_protection_mode = "VirtualNetworkInherited"

  tags = var.tags
}

############################################################
# Web Application Firewall policy
############################################################

resource "azurerm_web_application_firewall_policy" "this" {
  name                = local.waf_policy_name
  location            = var.location
  resource_group_name = var.resource_group_name

  policy_settings {
    enabled = true

    # Detection logs suspicious requests without blocking them.
    mode = "Detection"

    request_body_check               = true
    request_body_enforcement         = true
    request_body_inspect_limit_in_kb = 128

    file_upload_enforcement     = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  tags = var.tags
}

############################################################
# Application Gateway
############################################################

resource "azurerm_application_gateway" "this" {
  name                = local.application_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  http2_enabled      = true
  firewall_policy_id = azurerm_web_application_firewall_policy.this.id
  zones              = ["1", "2", "3"]

  ##########################################################
  # SKU and autoscaling
  ##########################################################

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  ##########################################################
  # Gateway subnet
  ##########################################################

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.app_gateway_subnet_id
  }

  ##########################################################
  # Public frontend
  ##########################################################

  frontend_port {
    name = "port_80"
    port = 80
  }

  frontend_ip_configuration {
    name = "appGwPublicFrontendIpIPv4"

    public_ip_address_id = (
      azurerm_public_ip.application_gateway.id
    )
  }

  ##########################################################
  # App Service backend
  ##########################################################

  backend_address_pool {
    name  = "pool-app-service"
    fqdns = [var.web_app_default_hostname]
  }

  backend_http_settings {
    name                  = "bhs-app-service-https"
    cookie_based_affinity = "Disabled"

    port            = 443
    protocol        = "Https"
    request_timeout = 30

    # App Service must receive its real Azure hostname.
    host_name = var.web_app_default_hostname

    probe_name = "probe-app-service"
  }

  ##########################################################
  # App Service health probe
  ##########################################################

  probe {
    name     = "probe-app-service"
    protocol = "Https"
    host     = var.web_app_default_hostname
    path     = "/"

    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    minimum_servers     = 0

    pick_host_name_from_backend_http_settings = false

    match {
      status_code = ["200-399"]
    }
  }

  ##########################################################
  # HTTP listener
  ##########################################################

  http_listener {
    name = "listener-http"

    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"

    protocol = "Http"
  }

  ##########################################################
  # Routing rule
  ##########################################################

  request_routing_rule {
    name      = "rule-http-to-app"
    rule_type = "Basic"
    priority  = 1

    http_listener_name         = "listener-http"
    backend_address_pool_name  = "pool-app-service"
    backend_http_settings_name = "bhs-app-service-https"
  }

  tags = var.tags
}
