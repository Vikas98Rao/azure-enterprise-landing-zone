# Azure Enterprise Landing Zone - Terraform

> Production-grade Azure Landing Zone aligned with Microsoft Cloud Adoption Framework (CAF).
> Implements Hub-and-Spoke networking, Management Groups hierarchy, RBAC with PIM, and Policy-as-Code.

---

## Architecture Overview

`
[ Tenant Root Group ]
        |
   Platform MG | Landing Zones MG | Sandbox MG
   |- Identity  | |- Corp          |
   |- Mgmt      | |- Online        |
   |- Connectivity| |- Dev         |
                | |- UAT           |
                | |- Prod          |
`

## Key Components

| Module | Description |
|---|---|
| modules/management-groups | Full MG hierarchy aligned to CAF |
| modules/hub-network | Hub VNet with Azure Firewall, VPN/ER GW, Private DNS |
| modules/spoke-network | Spoke VNets with peering and UDRs |
| modules/identity | Entra ID Groups, RBAC assignments, PIM config |
| modules/policy | CIS Azure Benchmark, MCSB initiative assignments |
| modules/monitoring | Centralized Log Analytics Workspace, DCR rules |

## Security Controls

- Azure Firewall Premium with TLS inspection
- Private Endpoints for all PaaS services
- NSGs + ASGs for micro-segmentation
- DDoS Protection Standard
- Defender for Cloud (P2) across all subscriptions
- Customer Managed Keys (CMK) for encryption at rest
- PIM Just-in-Time access with multi-stage approval

## Usage

`ash
terraform init -backend-config="environments/prod/backend.conf"
terraform plan -detailed-exitcode -out=tfplan
terraform apply tfplan
`

## Pipeline Stages

`
Lint -> Security Scan -> Cost Estimate -> Plan -> Approval Gate -> Apply -> Drift Detection
`

## Folder Structure

`
azure-enterprise-landing-zone/
+-- modules/
|   +-- management-groups/
|   +-- hub-network/
|   +-- spoke-network/
|   +-- identity/
|   +-- policy/
|   +-- monitoring/
+-- environments/
|   +-- dev/
|   +-- uat/
|   +-- prod/
+-- policies/
+-- pipelines/
    +-- azure-pipelines.yml
`

---
Senior DevOps Engineer - Vikas Rao