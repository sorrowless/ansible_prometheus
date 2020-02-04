#!/bin/bash

INSTALLED_OUT=`curl -X POST --header "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' localhost:9656 2>/dev/null`
RC=$?
INSTALLED_VERSION=-1
SUCCESSFULLY_RAN=1

if [[ $RC -ne 0 ]]; then
  SUCCESSFULLY_RAN=0
else
  INSTALLED_VERSION=`echo ${INSTALLED_OUT} | jq '.result' | perl -pe 's|"Geth\/v(.*?)-[\w/.-]+"$|\1|'`
fi

# Cache update only if it is older then a 12 hours
last_update=$(stat -c %Y /var/cache/apt/pkgcache.bin 2>/dev/null)
now=$(date +%s)
if [ $((now - last_update)) -gt 43200 ]; then
  apt-get update 2>/dev/null
fi

APT_INFO=$(apt-cache policy geth 2>/dev/null)
RC=$?

if [[ $RC -ne 0 ]]; then
  SUCCESSFULLY_RAN=0
fi

APT_INSTALLED=`echo ${APT_INFO} | perl -ne 'print $1 if m|\s+Installed:\s([\d.]+)\+.*|'`
APT_CANDIDATE=`echo ${APT_INFO} | perl -ne 'print $1 if m|\s+Candidate:\s([\d.]+)\+.*|'`

if [[ $APT_INSTALLED != $INSTALLED_VERSION ]]; then
  SUCCESSFULLY_RAN=0
fi

if [[ $APT_CANDIDATE != $INSTALLED_VERSION ]] && [[ $WARNING -eq 0 ]]; then
  SUCCESSFULLY_RAN=0
fi

if [[ $APT_INSTALLED == "" ]]; then
  APT_INSTALLED=-1
fi

if [[ $APT_CANDIDATE == "" ]]; then
  APT_CANDIDATE=-1
fi

echo "geth_version,installed=${INSTALLED_VERSION},apt_installed=${APT_INSTALLED},apt_candidate=${APT_CANDIDATE} geth_version_success=${SUCCESSFULLY_RAN}i"
