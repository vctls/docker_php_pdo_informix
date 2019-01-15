#!/bin/bash

PDO_DIRECTORY=PDO_INFORMIX-1.3.3
PDO_FILENAME=$PDO_DIRECTORY.tgz

TMPDIR=/tmp/files
TMPSDK=$TMPDIR/informixclient

tar  -xvf $TMPDIR/$PDO_FILENAME  -C $TMPDIR/
cd  $TMPDIR/$PDO_DIRECTORY
phpize  &&  ./configure  && make  &&  make install
