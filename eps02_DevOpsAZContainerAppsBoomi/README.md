# Boomi/Azure Hybrid Env Automation - Episode 2: Implement AVM Bicep into Azure DevOps and Perform Checks Against Boomi Atomsphere API

By: **[Jan Daris](https://intersky.nl)**, Intersky Integrations BV  

---

## Introduction

With **Azure DevOps**, **Boomi API**, and **Bicep Templates**, you can automate the complete lifecycle of a Boomi Atom or Molecule deployment. This ensures proper integration, scalability, and efficient management of your Boomi environment. 

In this guide, we’ll demonstrate how to:
- Validate or create a Boomi environment using the Boomi API.
- Validate Boomi Atom deployment status and handle installer token renewal using the Boomi API.
- Deploy Azure resources required for Boomi.
- Deploy a Boomi Atom or Molecule as an Azure Container App.

This tutorial assumes familiarity with:
- Azure DevOps pipelines  
- Azure Resource Manager (ARM) or Bicep  
- Boomi Installer Tokens and environment configurations  

For beginners, check out the [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/).

---

## Prerequisites

### Boomi Credentials
- A valid **Boomi AtomSphere API Token**.  
- Your **Boomi accountId**.  
- Boomi username with admin rights on your account.

### Azure Subscription
- Permissions to create resources (Owner role).  

### Azure DevOps
- A **Personal Access Token** to perform Read, Create & manage actions on **Variable Groups**.
- A **Service Connection** to set up a system connection with the Azure subscription where you have Owner permissions.
- A **Variable Group** per env with the following variables, change values to your own situation:

| **Variable**                | **Value**                                    | **Comments**                                   |
|-----------------------------|----------------------------------------------|-----------------------------------------------|
| `azureResourceRegion`       | `westeurope`                                | The Azure region where resources will be deployed. |
| `azureServiceConnection`    | `serviceConnection-Development`             | Azure DevOps Service Connection linked to the subscription. |
| `bicepParameterFile`        | `main.parameters.dev.json`                  | Parameter file for the Bicep template.        |
| `boomiAPIBaseUrl`           | `https://api.boomi.com/api/rest/v1/{YourBoomiAccountID}` | Base URL for Boomi API calls. Replace `{YourBoomiAccountID}` with your account ID. |
| `boomiAtomName`             | `BoomiAtomName`                             | The name of your Boomi Atom/Molecule.         |
| `boomiAtomOrMolecule`       | `ATOM`                                      | Specify `ATOM` or `MOLECULE` based on the deployment type. |
| `boomiBasicAuthPassword`    | `********`                                  | Your Boomi API authentication password (secure). |
| `boomiBasicAuthUsername`    | `********`                                  | Your Boomi API authentication username (secure). |
| `boomiContainerVersion`     | `atom:release`                              | The version of the Boomi Atom or Molecule container. Use `molecule:release` for Molecule. |
| `boomiEnvironmentClassification` | `TEST`                                 | Classification of the Boomi environment. Use `PROD` for production. |
| `boomiEnvironmentId`        | `6392345d-a1d3-424e-a03f-83ad810ac61c`      | The Boomi environment ID. Leave blank if not available upfront. |
| `boomiEnvironmentName`      | `Development`                               | The name of your Boomi environment.           |
| `devopsPatVariableGroup`    | `********`                                  | Your Azure DevOps Personal Access Token (PAT). Mark this as secure. |
| `libraryGroup`              | `boomi-dev`                                 | The name of your Azure DevOps variable group. |
| `subscriptionId`            | `********`                                  | The Azure subscription ID for the deployment. |
---

## File Structure

This repository includes:

1. **`main.bicep`**  
   Core template for Azure resource provisioning.
2. **`main.parameter.{env}.json`**  
   Parameter values for the Bicep deployment.
3. **PowerShell Scripts**:  
   - `validate-boomienv.ps1`: Handles Boomi Integration environment validation and updates.
   - `validate-boomi-atom.ps1`: Ensures the Atom is online or fetches a new installer token.
---

## Bicep Template

The [`main.bicep`](./main.bicep) file provisions:
- Azure Resource Group  
- Virtual Network with subnets for Container Apps and Storage  
- NFS-enabled Storage Account  
- Log Analytics Workspace  
- Managed Environment for Container Apps  
- Boomi Atom/Molecule deployment as a Container App  

---

## Pipeline Setup

The pipeline automates the following steps:
1. Validate or create a Boomi environment.
2. Deploy Azure resources via Bicep templates.
3. Validate Boomi Atom deployment status and handle installer token renewal.
4. Deploy the Boomi Atom or Molecule as a Container App.


## Next Steps
For a comprehensive guide, including use cases, best practices, and troubleshooting tips, visit our blog: [Automate Your Complete Hybrid Boomi/Azure Instance with Azure DevOps, Boomi Atomsphere API, AVM Bicep](https://intersky.nl/boomi-azure-hybrid-env-automation-episode-2-implement-avm-bicep-into-azure-devops-and-perform-checks-against-boomi-atomsphere-api/).

## Contact

**Questions or ready to start your integration project?**  
[Start Connecting? +31 6 57594183](tel:+31657594183)

**Website**: [https://intersky.nl](https://intersky.nl)  

©2025 Intersky Integrations BV | Written by **Jan Daris**