# Exit on error
$ErrorActionPreference = "Stop"

try {
	Set-ExecutionPolicy unrestricted
}
catch {
	Write-Warning $_
}

mkdir .\artifacts -Force
Remove-Item .\artifacts\* -Force

Write-Host "STEP 1 ------ Generating .app for each project"
Get-ChildItem -Directory | Where-Object Name -eq 'helloworld' | ForEach-Object {
	$iterator = $_
	try {
		$registered = $projects.$iterator
		Write-Host "Handling Project : " $iterator
		Write-Host "Registered Version: " $registered
		$projectJson = Get-Content -Raw -Path ".\$iterator\app.json"
		$projectConfig = ConvertFrom-Json $projectJson
		$current = $projectConfig.version
		Write-Host "Current Version: " $current
		
		$projects.$iterator = $current
		$modifiedVersion = $projects | ConvertTo-Json -Depth 100
		$modifiedVersion | Out-File -FilePath ".\version.json"
		Write-Host "Compiling " $iterator " with version " $current

		Write-Host $iterator
		$filenameApp = "$iterator-$current-application.app"
		Write-Host "Compiling $filenameApp"
		.\ALC\alc.exe /project:.\$iterator /out:.\artifacts\$filenameApp /packagecachepath:.\$iterator\.alpackages

		$registered = ""
	}
	catch {
		Write-Error "Something threw an exception"
	}
}
Write-Host "STEP 1 ------ Done"
