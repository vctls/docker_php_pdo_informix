#!/bin/bash

CSDK_FILENAME=clientsdk.4.10.FC9DE.LINUX.x86-64.tar

TMPDIR=/tmp/files
TMPSDK=$TMPDIR/informixclient

mkdir $TMPSDK

tar -xvf $TMPDIR/$CSDK_FILENAME  -C $TMPSDK

#Informix SDK's unattended installation
$TMPSDK/installclientsdk -i silent -f $TMPDIR/../csdk.properties
