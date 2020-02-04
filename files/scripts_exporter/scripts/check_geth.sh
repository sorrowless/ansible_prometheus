#!/bin/bash

PORT="${1:-9656}"
OUT=`geth attach http://localhost:$PORT --exec "eth.syncing" 2>&1`
IS_FALSE=`echo $OUT | grep -q "false"`
RC=$?
RESULT=1

if [[ $RC -eq 0 ]]; then
  RESULT=0
fi
echo "{ \"eth_syncing\": ${RESULT} }"
