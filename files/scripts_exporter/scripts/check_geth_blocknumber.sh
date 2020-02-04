#!/bin/bash

PORT="${1:-9656}"
OUT=`geth attach http://localhost:$PORT --exec "eth.blockNumber" 2>&1`
RC=$?
RESULT=-1

if [[ $RC -eq 0 ]]; then
  RESULT=${OUT}
fi
echo "{ \"block_number\": ${RESULT} }"
