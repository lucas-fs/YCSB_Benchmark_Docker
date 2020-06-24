#!/bin/bash

workload=$1
recordcount=$2

node_ip=`getent hosts tasks.seed | awk '{print $1}'| head -n 1`
echo "seed node ip: $node_ip"

ycsb run cassandra-cql -s -p hosts="$node_ip" -P $YCSB_HOME/workloads/workload$workload -p recordcount=$recordcount -cp $CLASSPATH
