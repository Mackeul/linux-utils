
# chkconfig: 35 99 99
# description: Mounts my usb drives.

# Configure all labels here (should be the volume name, case sensitive
allLabels="BM-Mobile1 BM-Mobile2 Hammer MC-FUJITSU SIMPLETOUGH"

# Loop on all labels configured above
for aLabel in $allLabels; do
  # See if label already mounted.
  if [ `mount -l|grep $aLabel|wc -l` -eq 0 ]; then
    # Not mounted as label, find file system with label
    aFileSystem=`findfs LABEL=$aLabel 2>/dev/null`
    aResult=$?
    #See if we found the label with the findfs
    if [ $aResult -eq 0 ]; then
      # See if what we found if findfs is already mounted somewhere.
      if [ `mount -l|grep $aFileSystem|wc -l` -eq 0 ]; then
        #Not already mounted, check to make sure there is a directory in /media
        if [ ! -d /media/$aLabel ]; then
          # Directory is not there, create it
          mkdir /media/$aLabel
        fi
        # Now mount the drive
        mount `findfs LABEL=$aLabel` /media/$aLabel
      fi
    fi
  fi  
done
