output "resource_group_name" {
  value       = module.resource_group.name
  description = "Resource Group Name"
}

output "vnet_name" {
  value       = module.virtual_network.name
  description = "Virtual Network Name"
}

output "subnet_ids" {
  value       = module.subnet.subnet_ids
  description = "Subnet IDs"
}

output "vm_private_ips" {
  value       = module.virtual_machine.private_ip_addresses
  description = "Private IP addresses for Frontend, Backend, Database VMs"
}

output "frontend_public_ip" {
  value       = module.public_ip.public_ip_addresses
  description = "Public IP address of Frontend VM"
}

output "acr_login_server" {
  value       = module.acr.login_server
  description = "ACR Login Server"
}

output "aks_cluster_name" {
  value       = module.aks.name
  description = "AKS Cluster Name"
}

output "postgres_fqdn" {
  value       = module.postgres.fqdn
  description = "PostgreSQL Server FQDN"
}
