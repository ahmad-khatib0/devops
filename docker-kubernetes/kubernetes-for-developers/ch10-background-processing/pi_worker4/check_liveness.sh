#!/bin/bash

# Liveness probe for batch process
# The process writes a logfile every time it runs with the current Unix timestamp.

# Usage: process_liveness.sh <path_to_file> <freshness_seconds>
# The file must contain only the latest date as a Unix timestamp and no newlines
#
# The goal of this script is simply to return the success exit code (0) when the 
# timestamp file exists and is not stale. And exit with a non-zero code on any errors

# Read the timestamp file from the input (parameter $1), and exit with an error if it doesn't exist
if [ -z "$1" ] || [ -z "$2" ]; then
  echo >&2 'Missing parameters'
  echo >&2 'Usage: process_liveness.sh <path_to_file> <freshness_seconds>'
  echo >&2 '  e.g: process_liveness.sh lastrun.date 300'
  exit 1
fi

if ! rundate=$(<$1); then
  echo >&2 "Failed: unable to read logfile"
  exit 2
fi

curdate=$(date +'%s')

# Compare the two timestamp
time_difference=$((curdate-rundate))

# Return an error status code if the process timestamp is older than 300 seconds
if [ $time_difference -gt $2 ]
then
  echo >&2 "Liveness failing, timestamp too old."
  exit 1
fi

# Return a success status code
exit 0

# livenessProbe:
#   initialDelaySeconds: 600 #A
#   periodSeconds: 30
#   exec: #B
#     command: ["./script/process_liveness.sh", "log/process.date"] #B
#   successThreshold: 1
#   timeoutSeconds: 1
