#!/bin/bash

workload=$1
recordcount=$2
replicas=$3

echo "[Execute Script] Getting a node ip..."
node_ip=`getent hosts tasks.seed | awk '{print $1}'| head -n 1`
echo "[Execute Script] Node ip: $node_ip"

echo "[Execute Script] replicas:$replicas workload:$workload recordcount:$recordcount"
$YCSB_HOME/bin/ycsb run cassandra-cql -s -p hosts="$node_ip" -P $YCSB_HOME/workloads/workload$workload -p recordcount=$recordcount -p rectime=3000 -cp $CLASSPATH > /ycsb_output/out-$replicas-$recordcount-$workload.txt 2>&1

chmod 777 /ycsb_output/out-$replicas-$recordcount-$workload.txt

echo "[Execute Script] Finished!"