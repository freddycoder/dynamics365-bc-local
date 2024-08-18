Write-Host "Generate a new self-signed certificate"
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -DnsName "localhost" -KeySpec KeyExchange

# Export the certificate as a PFX file
$certPath = "C:\certs\bc-erabliereapi-connector-certificate.pfx"
$certPassword = ConvertTo-SecureString -String "1234" -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath $certPath -Password $certPassword

# Export the certificate as a CER file
$certPath = "C:\certs\bc-erabliereapi-connector-certificate.cer"
Export-Certificate -Cert $cert -FilePath $certPath