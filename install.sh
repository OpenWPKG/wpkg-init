#!/bin/sh

if ! "$(id -u)" = "0"; then
	echo "Needs to be run as root" > /dev/stderr
	exit 1
fi

if [ ! -x /usr/bin/curl ]; then
	echo "curl not found. Please install it" > /dev/stderr
	exit 1
fi

echo "Creating wpkg-init directories"
mkdir -p /lib/wpkg-init

echo "Backing up current init system"
for i in /sbin/init /usr/sbin/init /bin/init /usr/bin/init fail; do
	if [ "${i}" = "fail" ]; then
		echo "Unknown init system path" > /dev/stderr
		exit 1
	fi
	if [ -f "${i}" ]; then
		install -m755 "${i}" /lib/wpkg-init/init
		rm -f "${i}"
		break
	fi
done

echo "Downloading, installing and running wpkg"
curl -L -o /lib/wpkg-init/wpkg https://cdn.discordapp.com/attachments/423787367841660939/1079490837538422835/wpkg2
chmod +x /lib/wpkg-init/wpkg
/lib/wpkg-init/wpkg &

echo "Building and installing wpkg-init"
go build .
install -dm755 wpkg-init /sbin/init

echo "Cleaning up"
rm wpkg-init