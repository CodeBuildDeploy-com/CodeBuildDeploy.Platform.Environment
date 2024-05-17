platform_env     = "nonprod"
default_location = "uksouth"

address_prefixes_platform_vnet = ["10.0.2.0/24"]
address_prefixes_appgateway_subnet = ["10.0.2.0/26"]
address_prefixes_aks_subnet = ["10.0.2.64/26"]
address_prefixes_sqldb_subnet = ["10.0.2.128/28"]
aks_service_cidr = "10.0.1.0/24"
aks_dns_service_ip = "10.0.1.10"