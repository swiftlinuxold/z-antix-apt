#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit
fi

USERNAME=$(logname)
is_chroot=0

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# If /home/$USERNAME exists, then we are not in chroot mode.
if [ -d "/home/$USERNAME" ]; then
	is_chroot=0
	DIR_DEVELOP=/home/$USERNAME/develop # not in chroot mode
else
	is_chroot=1
	DIR_DEVELOP=/usr/local/bin/develop # in chroot mode
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

