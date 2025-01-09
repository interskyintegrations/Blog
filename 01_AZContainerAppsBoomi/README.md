# How to Install a Boomi Atom or Molecule on Azure Container Apps Using AVM Bicep Templates

By: **[Jan Daris](https://intersky.nl)**, Intersky Integrations BV  
Contact: [Start Connecting? +31 6 57594183](tel:+31657594183)

---

## Introduction

When integrating and automating systems within an enterprise, scalability and maintainability are critical. By leveraging Azure Container Apps and Infrastructure as Code (IaC) via [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/), you can deploy a **Boomi Atom or Molecule** in a consistent and repeatable manner—centralizing your integration landscape and reaping the benefits of an efficient, containerized environment.  

In this tutorial, we'll walk through the **AVM Bicep template** configurations for creating:
- An Azure Resource Group
- A Virtual Network with subnets for Container Apps and Storage
- A Storage Account with NFS enabled
- A Log Analytics Workspace
- An Azure Container Apps Environment
- A Container App running a Boomi Atom or Molecule

This guide assumes you have basic familiarity with:
- Azure Resource Manager (ARM) or Bicep  
- Container concepts  
- Boomi Installation Tokens and environment configurations  

If you're new to Bicep, visit the [official documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/) to get started.

---

## Prerequisites

1. **Azure Subscription**  
   Make sure you have an active Azure subscription and the appropriate permissions (e.g., Owner or Contributor) on the target subscription.

2. **Azure CLI or PowerShell**  
   You’ll need either the [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) or [PowerShell with the Az module](https://learn.microsoft.com/powershell/azure/install-az-ps) to deploy the Bicep templates.

3. **Bicep CLI**  
   Although you can deploy `.bicep` files directly using the latest Azure CLI, installing the [Bicep CLI](https://learn.microsoft.com/azure/azure-resource-manager/bicep/install) locally can be helpful if you plan to build or validate templates offline.

4. **Boomi Token & Container Version**  
   - **Boomi Installer Token** (`boomiInstallerToken`): A secure token retrieved from Boomi that must be updated after each usage.
   - **Boomi Container Version** (`boomiContainerVersion`): The type of Boomi runtime you want to run (e.g., `atom:release`, `molecule:release`).

---

## File Structure

You’ll have two main files in your project:

1. **`main.bicep`**: The primary infrastructure definition file (see code below).  
2. **`main.parameters.json`**: Parameter values for your deployment (see code below).

The file structure could look like this:
. ├─ main.bicep └─ main.parameters.json
