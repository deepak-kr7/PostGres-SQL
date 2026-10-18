#!/usr/bin/env python3
"""
Azure Infrastructure Cost Estimator
Calculates and displays monthly cost estimates for Azure Terraform environments (dev, qa, prod)
without requiring any proprietary SaaS API keys.
"""

import sys
import os
import re

HOURLY_RATES = {
    # VM Sizes (US East / Central)
    "Standard_B1s": 0.0104,
    "Standard_B1ms": 0.0208,
    "Standard_B2s": 0.0416,
    "Standard_B2ms": 0.0832,
    "Standard_D2s_v5": 0.096,
    "Standard_D4s_v5": 0.192,
    "Standard_E4s_v5": 0.252,
    
    # PostgreSQL Flexible Server (SKU rates)
    "B_Standard_B1ms": 0.0180,
    "B_Standard_B2s": 0.0360,
    "GP_Standard_D2s_v3": 0.1440,
    
    # ACR
    "Basic": 0.167 / 24.0,       # $5.00/mo
    "Standard": 0.667 / 24.0,    # $20.00/mo
    "Premium": 1.667 / 24.0,     # $50.00/mo
    
    # Public IP
    "Standard_PIP": 0.0050,
    
    # Disks (per GB per hour estimate)
    "Standard_LRS": 0.048 / 730.0,
    "Premium_LRS": 0.135 / 730.0,
}

HOURS_PER_MONTH = 730

def parse_tfvars(tfvars_path):
    if not os.path.exists(tfvars_path):
        return None
    with open(tfvars_path, "r", encoding="utf-8") as f:
        content = f.read()
    return content

def estimate_cost(env_dir):
    tfvars_path = os.path.join(env_dir, "terraform.tfvars")
    content = parse_tfvars(tfvars_path)
    if not content:
        print(f"Error: {tfvars_path} not found.")
        return

    env_name = os.path.basename(env_dir)

    print("\n" + "=" * 86)
    print(f"         AZURE INFRASTRUCTURE ESTIMATED MONTHLY COST BREAKDOWN [{env_name.upper()}]")
    print("=" * 86)
    print(f"{'Component':<24} {'Resource / SKU':<28} {'Qty':<6} {'Rate/Hr':<12} {'Monthly Est.':<14}")
    print("-" * 86)

    total_monthly = 0.0

    # 1. Virtual Machines
    vms_block = re.search(r'vms\s*=\s*\{([\s\S]*?)\n\}', content)
    if vms_block:
        vm_matches = re.findall(r'name\s*=\s*"([^"]+)"[\s\S]*?vm_size\s*=\s*"([^"]+)"[\s\S]*?os_disk_type\s*=\s*"([^"]+)"[\s\S]*?os_disk_size_gb\s*=\s*(\d+)', vms_block.group(1))
    else:
        vm_matches = []
    for vm_name, vm_size, disk_type, disk_size in vm_matches:
        rate = HOURLY_RATES.get(vm_size, 0.05)
        monthly = rate * HOURS_PER_MONTH
        total_monthly += monthly
        print(f"{'Virtual Machine':<24} {f'{vm_name} ({vm_size})':<28} {'1':<6} {f'${rate:.4f}':<12} {f'${monthly:>8.2f}':<14}")
        
        # Disk cost
        disk_rate_gb = HOURLY_RATES.get(disk_type, 0.0001)
        disk_monthly = int(disk_size) * disk_rate_gb * HOURS_PER_MONTH
        total_monthly += disk_monthly
        print(f"{'  OS Disk':<24} {f'{disk_size}GB {disk_type}':<28} {'1':<6} {'Included':<12} {f'${disk_monthly:>8.2f}':<14}")

    # 2. AKS Cluster
    aks_size = re.search(r'aks_node_vm_size\s*=\s*"([^"]+)"', content)
    aks_count = re.search(r'aks_node_count\s*=\s*(\d+)', content)
    aks_name = re.search(r'aks_name\s*=\s*"([^"]+)"', content)
    if aks_size and aks_count:
        size = aks_size.group(1)
        count = int(aks_count.group(1))
        name = aks_name.group(1) if aks_name else "aks-cluster"
        rate = HOURLY_RATES.get(size, 0.05) * count
        monthly = rate * HOURS_PER_MONTH
        total_monthly += monthly
        print(f"{'AKS Worker Nodes':<24} {f'{name} ({count}x {size})':<28} {str(count):<6} {f'${rate:.4f}':<12} {f'${monthly:>8.2f}':<14}")
        print(f"{'  AKS Control Plane':<24} {'Cluster Management':<28} {'1':<6} {'Free Tier':<12} {'$    0.00':<14}")

    # 3. PostgreSQL Database
    psql_sku = re.search(r'postgres_sku_name\s*=\s*"([^"]+)"', content)
    psql_name = re.search(r'postgres_name\s*=\s*"([^"]+)"', content)
    if psql_sku:
        sku = psql_sku.group(1)
        name = psql_name.group(1) if psql_name else "postgres-server"
        rate = HOURLY_RATES.get(sku, 0.036)
        monthly = rate * HOURS_PER_MONTH
        total_monthly += monthly
        print(f"{'PostgreSQL Flexible':<24} {f'{name} ({sku})':<28} {'1':<6} {f'${rate:.4f}':<12} {f'${monthly:>8.2f}':<14}")

    # 4. Container Registry (ACR)
    acr_sku = re.search(r'acr_sku\s*=\s*"([^"]+)"', content)
    acr_name = re.search(r'acr_name\s*=\s*"([^"]+)"', content)
    if acr_sku:
        sku = acr_sku.group(1)
        name = acr_name.group(1) if acr_name else "acr"
        rate = HOURLY_RATES.get(sku, 0.0068)
        monthly = rate * HOURS_PER_MONTH
        total_monthly += monthly
        print(f"{'Container Registry':<24} {f'{name} ({sku})':<28} {'1':<6} {f'${rate:.4f}':<12} {f'${monthly:>8.2f}':<14}")

    # 5. Public IP
    pip_count = len(re.findall(r'allocation_method\s*=\s*"Static"', content))
    if pip_count > 0:
        rate = HOURLY_RATES["Standard_PIP"] * pip_count
        monthly = rate * HOURS_PER_MONTH
        total_monthly += monthly
        print(f"{'Public IP Address':<24} {'Standard Static IPv4':<28} {str(pip_count):<6} {f'${rate:.4f}':<12} {f'${monthly:>8.2f}':<14}")

    print("-" * 86)
    print(f"{'TOTAL ESTIMATED MONTHLY COST:':<59} {f'~${total_monthly:>8.2f} / month':<27}")
    print("=" * 86 + "\n")

if __name__ == "__main__":
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    estimate_cost(target_dir)
