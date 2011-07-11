#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit
fi

echo "UPDATING APT"

# Include Debian Squeeze and Lenny
echo "Replacing /etc/apt/sources.list"

rm /etc/apt/sources.list
cp ./etc_apt/sources.list /etc/apt
chown root:root /etc/apt/sources.list

# Install only required packages, not recommended ones
# Defaults to Debian Squeeze
echo "Replacing /etc/apt/apt.conf"
rm /etc/apt/apt.conf
cp ./etc_apt/apt.conf /etc/apt/
chown root:root /etc/apt/apt.conf

# Favor Debian Squeeze over Debian Lenny
echo "Replacing /etc/apt/preferences"
rm /etc/apt/preferences
cp ./etc_apt/preferences /etc/apt
chown root:root /etc/apt/preferences

# Update apt-get
apt-get update

