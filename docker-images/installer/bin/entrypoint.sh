#!/usr/bin/env bash

export ORIGPASSWD=$(cat /etc/passwd | grep dockerdev)
export ORIG_UID=$(echo $ORIGPASSWD | cut -f3 -d:)
export ORIG_GID=$(echo $ORIGPASSWD | cut -f4 -d:)

export DEV_UID=${DEV_UID:=$ORIG_UID}
export DEV_GID=${DEV_GID:=$ORIG_GID}

export ORIG_HOME=$(echo $ORIGPASSWD | cut -f6 -d:)

sed -i -e "s/:$ORIG_UID:$ORIG_GID:/:$DEV_UID:$DEV_GID:/" /etc/passwd
sed -i -e "s/dockerdev:x:$ORIG_GID:/dockerdev:x:$DEV_GID:/" /etc/group

usermod -u "$DEV_UID" dockerdev
usermod -g "$DEV_GID" dockerdev

chown -R dockerdev:dockerdev $ORIG_HOME

su - dockerdev
