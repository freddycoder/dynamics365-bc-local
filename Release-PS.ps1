param(
    [string] $clientID,
    [string] $clientSecret,
    [string] $environment,
    [string] $tenantId,
    [switch] $listExtensions,
    [switch] $removePreviousVersion
)

# exit on error
$ErrorActionPreference = "Stop"

try {
    Set-ExecutionPolicy unrestricted
}
catch {
    Write-Warning "Failed to set execution policy to unrestricted"
}

Write-Host "Install BcContainerHelper module"

Write-Host "Check if BcContainerHelper module is installed"
if (Get-Module -ListAvailable -Name BcContainerHelper) {
    Write-Host "BcContainerHelper module is already installed"
}
else {
    Write-Host "BcContainerHelper module is not installed"
    Write-Host "Install BcContainerHelper module"
    Install-Module BcContainerHelper -force
    Write-Host "BcContainerHelper module installed"
}

Write-Host "STEP 1 ------ BcAuthContext creation"
$authcontext = New-BcAuthContext `
    -clientID $clientID `
    -clientSecret $clientSecret `
    -TenantID $tenantId
Write-Host "STEP 1 ------ Done"

Write-Host "STEP 2 ------ List all companies of the environment"
$url = "https://api.businesscentral.dynamics.com/v2.0/$tenantId/$environment/api/microsoft/automation/v2.0/companies"
$token = $authcontext.AccessToken
$headers = @{
    'Authorization' = 'Bearer ' + $token
}
$result = Invoke-RestMethod -Uri $url -Headers $headers
Write-Host ($result.value | Format-List | Out-String)

$companyId = $result.value[0].id

$name = $result.value[0].name
Write-Host "Using company $name with id $companyId"

Write-Host "STEP 2 ------ Done"

if ($listExtensions) {
    Write-Host "STEP 3 ------ List extension of the environment"
    $url = "https://api.businesscentral.dynamics.com/v2.0/$tenantId/$environment/api/microsoft/automation/v2.0/companies($companyId)/extensions?"
    $token = $authcontext.AccessToken
    $headers = @{
        'Authorization' = 'Bearer ' + $token
    }
    $result = Invoke-RestMethod -Uri $url -Method GET -Headers $headers
    Write-Host ($result.value | Format-List | Out-String)
    Write-Host "STEP 3 ------ Done"
}

Write-Host "STEP 4 ------ Publish each extension in the artifacts folder"

Get-ChildItem ./'artifacts'/

Get-ChildItem -Path ".\artifacts" -Filter *.app | ForEach-Object {
        Write-Host "Publishing $_"
        $appFile = (Get-Item(".\artifacts\$_")).FullName
        Publish-BcContainerApp `
            -bcAuthContext $authContext `
            -environment $environment `
            -appFile $appFile `
            -ignoreIfAppExists `
            -sync `
            -install `
            -scope Tenant

        Write-Host "Published $_"
}
Write-Host "STEP 4 ------ Done"