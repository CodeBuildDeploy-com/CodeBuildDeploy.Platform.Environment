subscription_short_name = "premium"
platform_env            = "prod"
default_location        = "uksouth"

address_prefixes_platform_vnet     = ["10.0.2.0/24"]
address_prefixes_appgateway_subnet = ["10.0.2.0/26"]
address_prefixes_aks_subnet        = ["10.0.2.64/26"]
address_prefixes_sqldb_subnet      = ["10.0.2.128/28"]
address_prefixes_bastion_subnet    = ["10.0.2.248/29"]
aks_service_cidr                   = "10.0.1.0/26"
aks_dns_service_ip                 = "10.0.1.10"
aks_system_pool_vm_size            = "Standard_D2_v3"
aks_system_pool_min_count          = 1
aks_system_pool_max_count          = 3

container_registry          = "codebuilddeploy.azurecr.io"
container_registry_username = "codebuilddeploy"