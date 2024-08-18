openssl genrsa -out certificateprivate.key 2048
openssl req -new -key certificateprivate.key -out certificate.csr
openssl x509 -req -days 365 -in certificate.csr -signkey certificateprivate.key -out certificate.crt
openssl pkcs12 -export -out certificate.pfx -inkey certificateprivate.key -in certificate.crt
openssl rsa -in certificateprivate.key -pubout -out certificatepublickey.pem