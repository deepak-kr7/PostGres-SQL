output "id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "AKS Cluster ID"
}

output "name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "AKS Cluster Name"
}

output "oidc_issuer_url" {
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  description = "OIDC Issuer URL"
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "Raw kube_config"
}
