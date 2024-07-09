#!/bin/bash

# Define the namespace and app label for the query and user/password to interact with nodetool
export NAMESPACE="apigee"
export APP_LABEL="apigee-cassandra"

# Get the cassandra user and password from the secret, optionally set the user and password directly
export USER=`kubectl -n apigee get secrets apigee-datastore-default-creds -o jsonpath='{.data.jmx\.user}' | base64 -d`
export PASSWORD=`kubectl -n apigee get secrets apigee-datastore-default-creds -o jsonpath='{.data.jmx\.password}' | base64 -d`


# Nodetool list of commands to run
NODETOOL_COMMANDS=(
  "compactionhistory"
  "compactionstats"
  "describecluster"
  "failuredetector"
  "gcstats"
  "getcompactionthroughput"
  "getconcurrentcompactors"
  "getinterdcstreamthroughput"
  "getlogginglevels"
  "getstreamthroughput"
  "gettraceprobability"
  "gossipinfo"
  "info"
  "netstats"
  "proxyhistograms"
  "ring"
  "status"
  "statusbackup"
  "statusbinary"
  "statusgossip"
  "statushandoff"
  "statusthrift"
  "tablestats"
  "tpstats"
  "version"
)

# Loop through each pod matching the label in the specified namespace
for p in $(kubectl -n $NAMESPACE get pods -l app=$APP_LABEL --no-headers -o custom-columns=":metadata.name"); do
    # Loop through each nodetool command
    for cmd in "${NODETOOL_COMMANDS[@]}"; do
        # Define the filename for the output
        FILENAME="/tmp/k_nodetool_${cmd}_${p}_$(date +%Y.%m.%d_%H.%M.%S).txt"
        # Execute the nodetool command on the pod and write the output to the file
        kubectl -n $NAMESPACE exec "$p" -- bash -c "nodetool -u $USER -pw $PASSWORD $cmd" 2>&1 | tee "$FILENAME"
    done
done

# After the loops, create a tar.gz file containing all k_nodetool_* files
#tar -czvf /tmp/k_nodetool_files_$(date +%Y.%m.%d_%H.%M.%S).tar.gz /tmp/k_nodetool_*.txt