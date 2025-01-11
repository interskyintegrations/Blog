param (
    [string]$boomiBasicAuthUsername,
    [string]$boomiBasicAuthPassword,
    [string]$boomiAPIBaseUrl,
    [string]$boomiEnvironmentId,
    [string]$boomiEnvironmentName,
    [string]$boomiEnvironmentClassification,
    [string]$libraryGroup,
    [string]$devopsPat
)

# Generate Boomi Authorization Header
$username = $boomiBasicAuthUsername
$password = $boomiBasicAuthPassword
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("${username}:${password}"))
$boomiHeaders = @{
    Authorization  = "Basic $auth"
    Accept         = "application/json"
    'Content-Type' = "application/json"
}

# Generate Azure DevOps PAT Header
$devopsAuth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$devopsPat"))
$devopsHeaders = @{
    Authorization  = "Basic $devopsAuth"
    Accept         = "application/json"
    'Content-Type' = "application/json"
}

# Function to set pipeline output variable
function Set-PipelineVariable {
    param (
        [string]$name,
        [string]$value
    )
    Write-Host "##vso[task.setvariable variable=$name;isOutput=true]$value"
}

if (-not $boomiEnvironmentId) {
    # Create a New Environment
    Write-Host "No boomiEnvironmentId provided. Creating a new environment."
    $createUrl = "$boomiAPIBaseUrl/Environment"
    $body = @{
        classification = $boomiEnvironmentClassification
        name           = $boomiEnvironmentName
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        $response = Invoke-RestMethod -Uri $createUrl -Method POST -Headers $boomiHeaders -Body $body
        $newBoomiEnvironmentId = $response.id
        Write-Host "Boomi environment created successfully. New ID: $newBoomiEnvironmentId"

        # Output the new Boomi Environment ID as a pipeline variable
        Set-PipelineVariable -name "boomiEnvironmentId" -value $newBoomiEnvironmentId

        # Update the Azure DevOps Library Variable Group with the new ID
        Write-Host "Updating library group at path: $libraryGroup with new boomiEnvironmentId."
        $collectionUri = $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI
        $projectName = $env:SYSTEM_TEAMPROJECT
        $variableGroupUrl = "$collectionUri$projectName/_apis/distributedtask/variablegroups?groupName=${libraryGroup}&api-version=7.1"

        Write-Host "Fetch available variable group where groupname eq $libraryGroup..."
        $variableGroupResponse = Invoke-RestMethod -Uri $variableGroupUrl -Headers $devopsHeaders -Method GET

        Write-Host "Retrieved Variable Group:"
        $variableGroupResponse.value | ForEach-Object {
            Write-Host " - Name: $($_.name), ID: $($_.id)"
        }

        # Check if the specified group exists
        $variableGroup = $variableGroupResponse.value | Where-Object { $_.name -eq $libraryGroup }
        if ($null -eq $variableGroup) {
            Write-Error "Library group at path $libraryGroup not found. Ensure it exists and the pipeline has access."
            throw
        }

        $groupId = $variableGroup.id
        $variables = $variableGroup.variables
        $variables.boomiEnvironmentId = @{
            isSecret = $false
            value    = $newBoomiEnvironmentId
        }

        $updatedGroup = @{
            id        = $groupId
            name      = $libraryGroup
            type      = "Vsts"
            variables = $variables
        } | ConvertTo-Json -Depth 10 -Compress
        Write-Host "url: $collectionUri$projectName/_apis/distributedtask/variablegroups/${groupId}?api-version=5.1-preview.1"
        Invoke-RestMethod -Uri "$collectionUri$projectName/_apis/distributedtask/variablegroups/${groupId}?api-version=5.1-preview.1" -Headers $devopsHeaders -Method PUT -Body $updatedGroup

        Write-Host "Library group $libraryGroup updated successfully."
    }
    catch {
        Write-Error "Failed to create a new Boomi environment or update the library: $_"
        throw
    }
}
else {
    # Existing Environment Logic
    Write-Host "boomiEnvironmentId provided. Validating existing environment."
    $envCheckUrl = "$boomiAPIBaseUrl/Environment/$boomiEnvironmentId"

    $response = Invoke-RestMethod -Uri $envCheckUrl -Method GET -Headers $boomiHeaders -ErrorAction SilentlyContinue

    if ($response -eq $null) {
        Write-Error "Environment with ID $boomiEnvironmentId does not exist."
        throw "Environment not found."
    }

    if ($response.name -ne $boomiEnvironmentName) {
        Write-Host "Mismatch in environment name. Expected: $boomiEnvironmentName, Found: $($response.name). Updating environment."
        $updateUrl = "$boomiAPIBaseUrl/Environment/$boomiEnvironmentId"
        $body = @{
            classification = $boomiEnvironmentClassification
            id             = $boomiEnvironmentId
            name           = $boomiEnvironmentName
        } | ConvertTo-Json -Depth 10 -Compress

        try {
            Invoke-RestMethod -Uri $updateUrl -Method POST -Headers $boomiHeaders -Body $body
            Write-Host "Boomi environment updated successfully."
        }
        catch {
            Write-Error "Failed to update Boomi environment: $_"
            throw
        }
    }
    else {
        Write-Host "Boomi environment exists and matches the expected name."
        # Output the existing Boomi Environment ID as a pipeline variable
        Set-PipelineVariable -name "boomiEnvironmentId" -value $boomiEnvironmentId
    }
}
