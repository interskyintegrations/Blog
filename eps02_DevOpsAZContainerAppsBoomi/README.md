## azure-dev variable group
| **Variable**                | **Value**                                    | **Comments**                                   |
|-----------------------------|----------------------------------------------|-----------------------------------------------|
| `location`       | `westeurope`                                | The Azure region where resources will be deployed. |
| `azureServiceConnection`    | `serviceConnection-Production`              | Azure DevOps Service Connection linked to the production subscription. |
| `bicepParameterFile`        | `main.parameters.prd.json`                  | Parameter file for the Bicep template for production. |
| `subscriptionId`            | `********`                                  | The Azure subscription ID for the production environment. |

## boomi-dev variable group
| **Variable**                | **Value**                                    | **Comments**                                   |
|-----------------------------|----------------------------------------------|-----------------------------------------------|
| `boomiAtomName`             | `BoomiAtomName-Dev`                         | The name of your Boomi Atom for development.  |
|| `boomiContainerVersion`     | `atom:release`                              | The version of the Boomi Atom or Molecule container. Use `molecule:release` for Molecule. |
| `boomiEnvironmentId`        | `6392345d-a1d3-424e-a03f-83ad810ac61c`      | The Boomi environment ID for development. Leave blank if not available upfront. |
| `boomiInstallerToken`       | `********`                                  | Secure installer token for deploying Boomi Atom or Molecule. Update after each use. |

## azure-prod variable group
| **Variable**                | **Value**                                    | **Comments**                                   |
|-----------------------------|----------------------------------------------|-----------------------------------------------|
| `location`       | `westeurope`                                | The Azure region where resources will be deployed. |
| `azureServiceConnection`    | `serviceConnection-Production`              | Azure DevOps Service Connection linked to the production subscription. |
| `bicepParameterFile`        | `main.parameters.prd.json`                  | Parameter file for the Bicep template for production. |
| `subscriptionId`            | `********`                                  | The Azure subscription ID for the production environment. |


## boomi-prod variable group
| **Variable**                | **Value**                                    | **Comments**                                   |
|-----------------------------|----------------------------------------------|-----------------------------------------------|
| `boomiAtomName`             | `BoomiAtomName-Prod`                         | The name of your Boomi Atom for development.  |
|| `boomiContainerVersion`     | `atom:release`                              | The version of the Boomi Atom or Molecule container. Use `molecule:release` for Molecule. |
| `boomiEnvironmentId`        | `6392345d-a1d3-424e-a03f-83ad810ac61c`      | The Boomi environment ID for development. Leave blank if not available upfront. |
| `boomiInstallerToken`       | `********`                                  | Secure installer token for deploying Boomi Atom or Molecule. Update after each use. |
