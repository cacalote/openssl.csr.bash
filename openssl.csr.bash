#!/bin/bash
site_name="example.com"
email_address="webmaster@$site_name"
organization="$site_name"
organizational_unit="$site_name"
country="US"
state="AR"
city="Fayetteville"

use_subject_alternative_names=true

declare -a subject_alternative_names=(
  "www.example.com"
  "test.example.com"
  "example.net"
)

if $use_subject_alternative_names; then
  sanstring=""
  for san in ${subject_alternative_names[@]}; do
    sanstring="$sanstring""DNS:$san,"
  done
  # trim trailing comma
  sanstring=${sanstring::-1}

  # get default openssl.cnf
  opensslcnf=$(openssl version -d | cut -d '"' -f2)/openssl.cnf
  openssl req -new -nodes -sha256 -newkey rsa:2048 -keyout $site_name.key -out $site_name.csr -subj "/CN=$site_name/emailAddress=$email_address/O=$organization/OU=$organizational_unit/C=$country/ST=$state/L=$city" -reqexts SAN -config <(cat $opensslcnf <(printf "[SAN]\nsubjectAltName=$sanstring"))
else
  openssl req -new -nodes -sha256 -newkey rsa:2048 -keyout $site_name.key -out $site_name.csr -subj "/CN=$site_name/emailAddress=$email_address/O=$organization/OU=$organizational_unit/C=$country/ST=$state/L=$city"
fi
