platform_env     = "prod"
default_location = "uksouth"

address_prefixes_platform_vnet = ["10.0.1.0/24"]
address_prefixes_aks_subnet = ["10.0.1.0/26"]
address_prefixes_sqldb_subnet = ["10.0.1.128/28"]
aks_service_cidr = ["10.0.1.0/26"]