#!/bin/bash
# File: plex-create-p12.sh   Author: Michael Laporte
#
# Desc: Creates a p12 certificate with export key set to
#       hash of "plex" + Plex ProcessMachineIdentifier.



clear

echo "Plex Certificate File Generator."
echo "by Michael Laporte"
echo "
Copyright (C)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
echo " "
echo "Please press space to continue..."
read -r -n 1 -s -d ' '
clear
echo " "
echo " "

DOMAIN=example.com

CERT_FILE=$DOMAIN.crt
KEY_FILE=$DOMAIN.key
P12_FILE=$DOMAIN.p12
PMI=a1b2c3d4e5f6a7b8c9d0e1

echo "Using the following data for p12 file creation.  If any of this is wrong, edit the script accordingly."

echo "Domain: $DOMAIN"
echo "x509 Encoded Certificate file: $CERT_FILE"
echo "Certificate key file: $KEY_FILE"
echo "PKCS12 Certificate output file name: $P12_FILE"
echo "Plex ProcessedMachineIdentifier=$PMI"

echo "-----------------------"
echo "To verify if the Plex ProcessMachineIdentifier is still correct, find it in:"
echo " "
echo "/var/lib/plexmediaserver/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml"
echo " "
echo "and compare."
echo "-----------------------"

echo " "
echo "Please press space to continue..."
read -r -n 1 -s -d ' '
echo " "
echo " "

INPUT_STRING="plex$PMI"

echo "Generating P12 Key..."
P12_KEY=`echo -n "$INPUT_STRING" | openssl dgst -sha512 -r -hex | cut -d\  -f1`
echo "Saving key in plex-custom-cert-encryption-key.txt"
echo "$P12_KEY" >> plex-custom-cert-encryption-key.txt
echo "Creating p12 certificate file: $P12_FILE"
openssl pkcs12 -export -out $P12_FILE -in $CERT_FILE -inkey $KEY_FILE -name $DOMAIN -password pass:$P12_KEY

echo "-----------------------"

echo "Next steps:"
echo "----------"
echo "-> Install (copy/move) the p12 file ($P12_FILE) to desired location (eg. /etc/ssl/$DOMAIN, or wherever you prefer)."
echo "-> Note the full path to the file, you will need it in Plex."
echo " "
echo "-> Note the P12 key:"
echo "    $P12_KEY"
echo "   it can also be found in the file plex-custom-cert-encryption-key.txt."
echo " "
echo "-----------------------"
echo " "
echo "Login to Plex Media Server, click on the Settings button (wrench top right) and go to: "
echo " "
echo "   Settings -> Network "
echo " "
echo "-> Enter full path to installed p12 file (/path/to/$P12_FILE) in Custom Certificate Location field."
echo "-> Paste the key ($P12_KEY) in the Custom Certificate Encryption Key field."
echo "-> Enter the domain ($DOMAIN) in the Custom Certificate Domain field."
echo " "
echo "-----------------------"
echo " "
echo "*Note: You may need to restart plexmediaserver.  You may also need to clear your browser cache and/or restart your browser".
