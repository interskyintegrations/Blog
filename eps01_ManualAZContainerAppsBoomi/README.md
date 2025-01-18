# Boomi/Azure Hybrid Env Automation - Episode 1: How to Install a Boomi Atom or Molecule on Azure Container Apps Using AVM Bicep Templates

By: **[Jan Daris](https://intersky.nl)**, Intersky Integrations BV  
Contact: [Start Connecting? +31 6 57594183](tel:+31657594183)

---

## Introduction

By using **Azure Container Apps** and **Infrastructure as Code (IaC)** via [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/), you can deploy a **Boomi Atom or Molecule** in a consistent, repeatable manner. This setup centralizes your integration landscape, ensuring scalability and maintainability.  

In this guide, we’ll demonstrate how to:
- Create an Azure Resource Group
- Provision a Virtual Network (VNet) with subnets for Container Apps and Storage
- Set up a Storage Account (NFS enabled)
- Deploy a Log Analytics Workspace
- Set up a Container Apps Environment
- Launch a Boomi Atom or Molecule as a Container App

This tutorial assumes familiarity with:
- Azure Resource Manager (ARM) or Bicep  
- Containerization basics  
- Boomi Installer Tokens and environment configurations  

For those new to Bicep, check out the [official documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/).

---
> **Note** This implementation is an easy example and not something you should deploy to PROD! Make sure to modify the template according your business needs and purpose and make sure to check both Boomi's and Azure's best practises.

## Prerequisites

1. **Azure Subscription**  
   - An active Azure subscription with permissions to create resources (e.g., Owner or Contributor).
2. **Azure CLI or PowerShell**  
   - Install [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) or  
   - [PowerShell with the Az module](https://learn.microsoft.com/powershell/azure/install-az-ps)
3. **Bicep CLI** (optional)  
   - The [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) can be used locally to compile or validate templates if needed.
4. **Boomi Installer Token & Container Version**  
   - A valid **Boomi Installer Token** that must be refreshed regularly.  
   - The **Boomi Container Version**, e.g., `atom:release`, `molecule:release`, etc.
5. **Boomi Environment ID**  
   - A valid boomi environment ID guid is needed to connect the atom/molceule to a Boomi environment.

---
## High Level Design
![image](https://github.com/user-attachments/assets/7a2aa5e4-1719-441d-ba95-42684caa213e)


---
## File Structure

Within this GitHub repository, we have two files:

1. **`main.bicep`**  
2. **`main.parameters.json`**

These files define the entire deployment.


---

## main.bicep

The [`main.bicep`](./main.bicep) file contains all the resources needed to spin up a Boomi Atom or Molecule on Azure Container Apps, including:
- Resource Group creation
- Virtual Network (with AVM module)
- Storage Account setup with NFS shares
- Log Analytics Workspace
- Managed Container Apps Environment
- Boomi Container App deployment

> **Check the code in your GitHub repo** for the full Bicep configuration.

---

## main.parameters.json

The [`main.parameters.json`](./main.parameters.json) file contains the parameter values (e.g., names, IDs, locations, Boomi tokens, etc.) needed to customize your deployment.

> **Remember** to replace placeholder values (e.g., subscription ID, Boomi token) with valid entries before deployment.

---

## Deployment Info
More info on my blog: [Boomi & Azure Hybrid Environment – Episode 1: How to install a Boomi Atom or Molecule on Azure Container Apps using AVM Bicep templates
](https://intersky.nl/boomi-azure-hybrid-environment-episode-1-how-to-install-a-boomi-atom-or-molecule-on-azure-container-app-using-avm-bicep-templates/)

## Contact

**Questions or ready to start your integration project?**  
[Start Connecting? +31 6 57594183](tel:+31657594183)

**Website**: [https://intersky.nl](https://intersky.nl)  
**Email**: [info@intersky.nl](mailto:info@intersky.nl)  
**Linkedin**[Jan Daris](https://www.linkedin.com/in/jandaris/)

©2025 Intersky Integrations BV | Written by [**Jan Daris**](https://www.linkedin.com/in/jandaris/)
