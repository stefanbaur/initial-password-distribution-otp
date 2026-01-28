#!/bin/bash

# set default
INSTALL_DIR=/opt/initial-password-distribution-otp

# override default if different directory has been given
[ -n "$1" ] && INSTALL_DIR="$1"

# change to our working directory, to make relative paths work
cd $(dirname $0)

if [ -s ${INSTALL_DIR}/etc/initpass.conf ] ; then
	TIMESTAMP=$(date +%s)
	echo "Config file already present."
	echo "Moving your old config to: '${INSTALL_DIR}/etc/initpass.conf.${TIMESTAMP}'"
	mv ${INSTALL_DIR}/etc/initpass.conf ${INSTALL_DIR}/etc/initpass.conf.${TIMESTAMP}
fi

# copy all files to $INSTALL_DIR/initial-password-distribution-otp/{bin,etc,data}
rsync -aPvH {bin,etc,data} $INSTALL_DIR/

# patch config file
sed -e '/OTPDIR/c OTPDIR="'$INSTALL_DIR'/"' -i ${INSTALL_DIR}/etc/initpass.conf

# create symlinks to our executables in /usr/local/sbin
for FILE in ${INSTALL_DIR}/bin/* ; do
	ln -sf $FILE /usr/local/sbin/$(basename $FILE)
done

# point out all changes to the admin
if [ -n "$TIMESTAMP" ] ; then
	echo "Please have a look at the differences between your old and current config."
	echo "For your convenience, here is the output of 'diff':"
	diff ${INSTALL_DIR}/etc/initpass.conf ${INSTALL_DIR}/etc/initpass.conf.${TIMESTAMP}
fi
