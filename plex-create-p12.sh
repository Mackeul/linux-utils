#!/bin/bash

echo "Running python p12 generator script for Plex..."
CERT=
KEY=
PMI=
echo "-----------------------"
echo ""
echo "Using ProcessedMachineIdentifier=$PMI"
echo "To verify if still correct, find it in the /var/lib/plexmediaserver/Library/Application\ Support/Plex\ Media\ Server/Preferences.xml and compare."
echo ""
echo "-----------------------"
echo ""
echo "pem2plex.py -> wget https://raw.githubusercontent.com/sadsfae/misc-scripts/master/python/pem2plex.py"
python pem2plex.py $CERT $KEY $PMI
echo ""
echo "-----------------------"
echo ""
echo "Next steps:"
echo ""
echo "Copy/move the p12 certificate.p12 file to desired location(ie. /etc/ssl/certs, or wherever)."
echo "Copy the long key that got printed above..."
echo "Login to Plex Media Server and go to Settings -> Server -> Network"
echo "Enter location of p12 file, and paste in the key."
echo "Restart the Plex Media Server to load up the new cert."
