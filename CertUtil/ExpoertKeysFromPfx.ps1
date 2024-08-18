Write-Host "Exporting keys from PFX file..."

$pfxFile = "bc-erabliereapi-connector-certificate.pfx"
$keyFile = "bc-erabliereapi-connector-certificate.key"
$certFile = "bc-erabliereapi-connector-certificate.crt"
$password = "1234"

openssl pkcs12 -in $pfxFile -nocerts -out $keyFile -nodes -password pass:$password
openssl pkcs12 -in $pfxFile -clcerts -nokeys -out $certFile -password pass:$password

Write-Host "Exporting keys from PFX file... Done"