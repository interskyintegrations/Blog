param (
    [string]$boomiBasicAuthUsername,
    [string]$boomiBasicAuthPassword,
    [string]$boomiAPIBaseUrl,
    [string]$boomiAtomName,
    [string]$boomiEnvironmentId,
    [string]$boomiAtomOrMolecule
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

# Function to set pipeline output variable
function Set-PipelineVariable {
    param (
        [string]$name,
        [string]$value
    )
    Write-Host "##vso[task.setvariable variable=$name;isOutput=true]$value"
}

# Check if Atom exists
$queryUrl = "$boomiAPIBaseUrl/Atom/query"
$queryBody = @{
    QueryFilter = @{
        expression = @{
            operator = "CONTAINS"
            property = "name"
            argument = @($boomiAtomName)
        }
    }
} | ConvertTo-Json -Depth 10 -Compress

try {
    $response = Invoke-RestMethod -Uri $queryUrl -Method POST -Headers $boomiHeaders -Body $queryBody
}
catch {
    Write-Error "Failed to query Atom: $_"
    exit 1
}

if ($response.result.Count -eq 0 -or $response.result[0].status -ne "ONLINE") {
    Write-Host "Atom not found or is not online. Requesting new installer token."
    $installerTokenUrl = "$boomiAPIBaseUrl/InstallerToken"
    $tokenBody = @{
        durationMinutes = "1440"
        installType     = $boomiAtomOrMolecule
    } | ConvertTo-Json -Depth 10 -Compress

    try {
        $tokenResponse = Invoke-RestMethod -Uri $installerTokenUrl -Method POST -Headers $boomiHeaders -Body $tokenBody
    }
    catch {
        Write-Error "Failed to retrieve installer token: $_"
        exit 1
    }

    if ($tokenResponse -and $tokenResponse.token) {
        Write-Host "Installer token retrieved successfully."
        # Set the installer token as an output variable
        Set-PipelineVariable -name "boomiInstallerToken" -value $tokenResponse.token
    }
    else {
        Write-Error "Installer token response is invalid."
        exit 1
    }
}
else {
    Write-Host "Atom is online and valid. No new installer token required."
}
