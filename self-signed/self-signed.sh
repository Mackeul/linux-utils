#!/bin/bash
#
# File: self-signed.sh
#
# Desc: A script to generate a self-signed domain wildcard certificate.
#
# Input parameters:
#   domain.tld: Optional - The domain for which a wildcard certificate is to be generated.
#               Example: mydomain.com
#

_x=0

INPUT_DOMAIN=$1
DEFAULT_DOMAIN=example.com
DOMAIN=${INPUT_DOMAIN:=$DEFAULT_DOMAIN}

# Create certs good for 100 years.
NUM_DAYS=36500

CA_KEY_FILE=$DOMAIN.CAPrivate.key
CA_ROOT_FILE=$DOMAIN.CAPrivate.pem
KEY_FILE=$DOMAIN.key
CSR_FILE=$DOMAIN.csr
CERT_FILE=$DOMAIN.crt
SSL_EXT_FILE=$DOMAIN.openssl.ss.cnf
PFX_FILE=$DOMAIN.pfx
PFX_NAME=$DOMAIN

# Passphrase file setup.
PASS_FILE=pass.$DOMAIN.txt

PASSIN=""
PASSOUT=""
if [ -s "$PASS_FILE" ]; then
    echo "[$((_x++))] Using passphrase file: $PASS_FILE"
    PASSIN=" -passin file:$PASS_FILE"
    PASSOUT=" -passout file:$PASS_FILE"
fi

# Template config file setup.
TEMP_FILE=temp.$DOMAIN.txt 
if [ -s "$TEMP_FILE" ]; then
    echo "[$((_x++))] Using template file: $TEMP_FILE"
    TEMPCONFIG=" -config $TEMP_FILE"
fi

echo ""
echo " ------------------ "
echo ""

echo "[$((_x++))] Generating CA Root Key File..."
openssl genrsa -des3 -out $CA_KEY_FILE $PASSOUT 2048
echo ""
echo " ------------------ "
echo ""

echo "[$((_x++))] Generating CA Root Certificate..."
openssl req $TEMPCONFIG -section rootcert -extensions rootcert_ext -x509 -new -nodes -key $CA_KEY_FILE -out $CA_ROOT_FILE -days $NUM_DAYS -sha256 $PASSIN
#
# Make a copy with .crt for Windows
cp $CA_ROOT_FILE $CA_ROOT_FILE.crt


echo ""
echo " ------------------ "
echo ""

echo "[$((_x++))] Creating 2048-bit private key..."
openssl genrsa -out $KEY_FILE 2048

echo ""
echo " ------------------ "
echo ""

echo "[$((_x++))] Generating Certificate Signing Request (CSR) file..."
#openssl req $TEMPCONFIG -new -key $KEY_FILE -extensions v3_ca -out $CSR_FILE
openssl req $TEMPCONFIG -section cert -new -key $KEY_FILE -out $CSR_FILE

#echo ""
#echo " ------------------ "
#echo ""

#echo "Creating openssl extensions file..."
#echo "basicConstraints=CA:FALSE" > $SSL_EXT_FILE
#echo "subjectAltName=DNS:*.$DOMAIN" >> $SSL_EXT_FILE
#echo "extendedKeyUsage=serverAuth" >> $SSL_EXT_FILE

echo ""
echo " ------------------ "
echo ""

echo "[$((_x++))] Generating x509 certificate using CSR ..."
#openssl x509 -req -in $CSR_FILE -CA $CA_ROOT_FILE -CAkey $CA_KEY_FILE -CAcreateserial -extfile $SSL_EXT_FILE -out $CERT_FILE -days $NUM_DAYS -sha256 $PASSIN
openssl x509 -req -in $CSR_FILE -CA $CA_ROOT_FILE -CAkey $CA_KEY_FILE -CAcreateserial -copy_extensions=copy -out $CERT_FILE -days $NUM_DAYS -sha256 $PASSIN
echo ""
echo " ------------------ "
echo ""

echo "[$((_x++))] Generating pkcs12 certificate ..."
openssl pkcs12 -export -out $PFX_FILE -in $CERT_FILE -inkey $KEY_FILE -name $PFX_NAME -password pass:

echo ""
echo " ------------------ "
echo "Done."
echo ""
echo "Next steps:"
echo " 1. Install the Certificate / Private Key ($CERT_FILE & $KEY_FILE) on your Web Server / Application that will service secure requests."
echo "   -> Read the manual of the Web Server / Application to install SSL certificates."
echo ""
echo " 2. Copy the CA Root certificate ($CA_ROOT_FILE) and import it in the proper Certificate Store of the OS/Applications that will access the server."
echo "   -> [Windows] Copy $CA_ROOT_FILE.crt to computer, and import to Trusted Root Authorities Store."
