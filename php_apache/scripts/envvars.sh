#!/bin/bash

echo "
INFORMIXDIR=/opt/IBM/informix
export INFORMIXDIR

DB_LOCALE=en_US.CP1252
export DB_LOCALE
" >> /etc/apache2/envvars
