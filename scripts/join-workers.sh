#!/bin/bash
set -e
# Run on worker
if [ -f /tmp/join_cmd.sh ]; then
  bash /tmp/join_cmd.sh
else
  echo "Join command not present at /tmp/join_cmd.sh"
  exit 1
fi