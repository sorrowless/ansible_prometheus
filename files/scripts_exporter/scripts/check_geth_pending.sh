#!/bin/bash

PORT="${1:-9656}"
OUT=$(geth attach http://localhost:${PORT} --exec "eth.pendingTransactions.length" 2>/dev/null)
RC=$?
RESULT=-1

if [[ $RC -eq 0 ]]; then
  RESULT=${OUT}
fi
echo "{ \"pending_transactions\": ${RESULT} }"
