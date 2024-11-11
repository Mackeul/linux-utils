#!/bin/bash
#
# File: self-signed.sh
#
# Desc: A script to generate a self-signed domain wildcard certificate.
#
# Input parameters:
#   domain.tld: The domain for which a wildcard certificate is to be generated.
#               Example: mydomain.com
#
if [ $# -eq 0 ]; then
    echo "No domain given."
    echo "Usage: $0 <domain.tld>"
    exit 1
else
    DOMAIN=$1
    CA_KEY_FILE=$DOMAIN.CAPrivate.key
    CA_ROOT_FILE=$DOMAIN.CAPrivate.pem
    KEY_FILE=$DOMAIN.key
    CSR_FILE=$DOMAIN.csr
    CERT_FILE=$DOMAIN.crt
    SSL_EXT_FILE=$DOMAIN.openssl.ss.cnf
    PFX_FILE=$DOMAIN.pfx
    PFX_NAME=$DOMAIN
fi

echo "Creating 2048-bit CA Private Key...(requires passphrase)"
openssl genrsa -des3 -out $CA_KEY_FILE 2048

echo ""
echo " ------------------ "
echo ""

echo "Generating CA Root Certificate... (use passphrase entered above)"
openssl req -x509 -new -nodes -key $CA_KEY_FILE -sha256 -days 365 -out $CA_ROOT_FILE

echo ""
echo " ------------------ "
echo ""

echo "Creating 2048-bit private key..."
openssl genrsa -out $KEY_FILE 2048

echo ""
echo " ------------------ "
echo ""

echo "Generating Certificate Signing Request (CSR) file...(leave challenge password blank)"
openssl req -new -key $KEY_FILE -extensions v3_ca -out $CSR_FILE

echo ""
echo " ------------------ "
echo ""

echo "Creating openssl extensions file..."
echo "basicConstraints=CA:FALSE" > $SSL_EXT_FILE
echo "subjectAltName=DNS:*.$DOMAIN" >> $SSL_EXT_FILE
echo "extendedKeyUsage=serverAuth" >> $SSL_EXT_FILE

echo ""
echo " ------------------ "
echo ""

echo "Generating x509 certificate using CSR ...(use passphrase entered above)"
openssl x509 -req -in $CSR_FILE -CA $CA_ROOT_FILE -CAkey $CA_KEY_FILE -CAcreateserial -extfile $SSL_EXT_FILE -out $CERT_FILE -days 365 -sha256

echo ""
echo " ------------------ "
echo ""

echo "Generating pkcs12 certificate ...(leave export password blank)"
openssl pkcs12 -export -out $PFX_FILE -in $CERT_FILE -inkey $KEY_FILE -name $PFX_NAME

echo ""
echo " ------------------ "
echo "Done."
echo ""
echo "Next steps:"
echo " - Install the Certificate / Private Key on your Web Server / Application"
echo "   -> Read the manual of the Web Server / Application to install SSL certificates."
echo " - Copy the CA Root certificate and import it in the proper Certificate Store of the OS/Application"
echo "   -> [Windows] Copy CAPrivate.pem to computer, rename to CAPrivate.crt and import to Trusted Root Authorities Store."

