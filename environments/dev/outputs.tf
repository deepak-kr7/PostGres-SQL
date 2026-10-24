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

output "vm_public_ips" {
  value       = module.public_ip.public_ip_addresses
  description = "Public IP addresses for Frontend, Backend, and Database VMs"
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

output "key_vault_name" {
  value       = module.key_vault.key_vault_name
  description = "Azure Key Vault name"
}

output "key_vault_uri" {
  value       = module.key_vault.key_vault_uri
  description = "Azure Key Vault URI"
}

output "vm_admin_password" {
  value       = module.key_vault.vm_admin_password
  sensitive   = true
  description = "VM Admin Password (command: terraform output -raw vm_admin_password)"
}

output "db_admin_password" {
  value       = module.key_vault.db_admin_password
  sensitive   = true
  description = "Database Admin Password (command: terraform output -raw db_admin_password)"
}

output "bastion_name" {
  value       = module.bastion.bastion_name
  description = "Azure Bastion Host Name"
}

output "bastion_dns_name" {
  value       = module.bastion.bastion_dns_name
  description = "Azure Bastion DNS / FQDN"
}

output "bastion_public_ip" {
  value       = module.bastion.bastion_public_ip
  description = "Azure Bastion Public IP"
}

