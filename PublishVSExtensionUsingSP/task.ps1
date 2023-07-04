<#
    .SYNOPSIS
    This script publishes a visual studio extension using a service principal.
    .DESCRIPTION
    This script publishes a visual studio extension using a service principal.
    .NOTES
    Written by Deepam Sarmah (t-dsarmah@microsoft.com)
    #>

    [string]$TenantID = Get-VstsInput -Name TenantID
    [string]$ManifestFile = Get-VstsInput -Name ManifestFile
    [string]$ManifestFolder = Get-VstsInput -Name ManifestFolder

    Write-Host "Logging in with a service principal..."

    az login --allow-no-subscriptions --service-principal --tenant $TenantID --username ${env:CLIENT_ID} --password ${env:CLIENT_SECRET}

    Write-Host "Obtaining access token for service principal..."
    
    $accessToken = az account get-access-token --resource 499b84ac-1321-427f-aa17-267ca6975798 --query "accessToken" --output tsv
    
    $localPath = Join-Path $env:System_DefaultWorkingDirectory $ManifestFile

    $Response = Get-Content -Path $localPath

    $ResponseObject = $Response | ConvertFrom-Json

    $localPathFolder = Join-Path $env:System_DefaultWorkingDirectory $ManifestFolder

    Set-Location -Path $localPathFolder

    Write-Host "Installing dependencies..."

    npm i azure-devops-extension-sdk
    npm i vss-web-extension-sdk

    Write-Host "Publishing extension..."

    tfx extension publish --publisher $ResponseObject.publisher --auth-type pat -t $accessToken