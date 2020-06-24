#!/bin/bash

workload=$1
recordcount=$2
replicas=$3

node_ip=`getent hosts tasks.seed | awk '{print $1}'| head -n 1`
echo "seed node ip: $node_ip"

$YCSB_HOME/bin/ycsb run cassandra-cql -s -p hosts="$node_ip" -P $YCSB_HOME/workloads/workload$workload -p recordcount=$recordcount -cp $CLASSPATH > /ycsb_output/out-$replicas-$recordcount-$workload.txt 2>&1