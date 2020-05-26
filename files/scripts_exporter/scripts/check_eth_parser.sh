#!/bin/bash

FAILED=0
if [ -z $1 ]; then
  FAILED=1
fi

URL=$1

OUT=`curl $URL 2>/dev/null`
RC=$?
if [ "$RC" -ne "0" ]; then
  FAILED=1
fi

echo $OUT | jq '.data|ascii_downcase == "ok"' 2>/dev/null | grep -q "true"
RC=$?

if [ "$RC" -ne "0" ]; then
  FAILED=1
fi

echo "{ \"parser_check_failed\": ${FAILED} }"
