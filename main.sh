#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit 2
fi

IS_CHROOT=0 # changed to 1 if and only if in chroot mode
USERNAME=""
DIR_DEVELOP=""

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# /srv directory only exists in chroot mode
if [ -d "/srv" ]; then
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
else
	USERNAME=$(logname) # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
fi


echo "UPDATING APT"

# Include Debian Wheezy and Squeeze
echo "Replacing /etc/apt/sources.list"

rm /etc/apt/sources.list
cp $DIR_DEVELOP/apt/etc_apt/sources.list /etc/apt
chown root:root /etc/apt/sources.list

# Install only required packages, not recommended ones
# Defaults to Debian Squeeze
echo "Replacing /etc/apt/apt.conf"
rm /etc/apt/apt.conf
cp $DIR_DEVELOP/apt/etc_apt/apt.conf /etc/apt/
chown root:root /etc/apt/apt.conf

# Favor Debian Wheezy over Debian Squeeze
echo "Replacing /etc/apt/preferences"
rm /etc/apt/preferences
cp $DIR_DEVELOP/apt/etc_apt/preferences /etc/apt
chown root:root /etc/apt/preferences

# Update apt-get
apt-get update

exit 0
