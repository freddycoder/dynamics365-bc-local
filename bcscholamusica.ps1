$containerName = 'bcscholamusica'
$password = 'P@ssw0rd'
$securePassword = ConvertTo-SecureString -String $password -AsPlainText -Force
$credential = New-Object pscredential 'admin', $securePassword
$auth = 'UserPassword'
$artifactUrl = Get-BcArtifactUrl -type 'Sandbox' -country 'ca' -select 'Latest'
$licenseFile = '→'
New-BcContainer `
    -accept_eula `
    -containerName $containerName `
    -credential $credential `
    -auth $auth `
    -artifactUrl $artifactUrl `
    -imageName 'bcscholamusicaimage' `
    -includeTestToolkit `
    -includePerformanceToolkit `
    -licenseFile $licenseFile `
    -usessl -installCertificateOnHost `
    -memoryLimit 4g-8G `
    -includeAL `
    -vsixFile (Get-LatestAlLanguageExtensionUrl) `
    -updateHosts