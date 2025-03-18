# linux-utils
Scripts, configs, etc... useful in Linux.

## The self-signed.sh script

The self-signed.sh script is designed to create a self-signed wildcard certificate that is good for 100 years.  The user can then use the certificate on servers and install the Root certificate as a trusted authority on clients.  Once installed, we hopefully never have to deal with certs again on the same machines.

- **Input parameters**: *domain.tld*.  Default is example.com in script if not provided.
    - Example: /bin/sh self-signed.sh example.com

- *Optional pass.domain.tld.txt* file containing passphrase can be used to provide the same passphrase in all steps. 
    - Example: pass.example.com.txt containing one line it with the passphrase: my password.  See pass.example.com.txt.

- *Optional temp.domain.tld.text* file containing sections for rootcert and cert. See temp.example.com.txt.

## The plex-create-p12.sh script
Designed to create a PKCS12 certificate with export passphrase set to how Plex wants it.  Uses OpenSSL to accomplish this, that is required to be installed.  Requires a PEM cert file and key file to work (see self-signed to make your own).  Also needs the ProcessMachineIdentifier key from Plex, which can be found in 
**/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml** on Debian servers.
