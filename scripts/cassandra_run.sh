#!/bin/bash

node_ip=$1
workload=$2
recordcount=$3
replicas=$4
exe=$5
rf=$6

echo "[RUN Script] replicas:$replicas workload:$workload \
      recordcount:$recordcount exec:$exe"

$YCSB_HOME/bin/ycsb run cassandra-cql -s \
-p hosts="$node_ip" \
-P $YCSB_HOME/workloads/workload$workload \
-p recordcount=$recordcount \
-p rectime=3000 \
-p cassandra.connecttimeoutmillis=60000 \
-p cassandra.readtimeoutmillis=60000 \
-p cassandra.readconsistencylevel=ONE \
-p cassandra.writeconsistencylevel=ONE \
-p operationcount=10000 \
-cp $CLASSPATH \
> /ycsb_outputs/out-$replicas-$recordcount-rf$rf-$workload-$exe.txt 2>&1

chmod 777 /ycsb_outputs/out-$replicas-$recordcount-rf$rf-$workload-$exe.txt

echo "[RUN Script] Finished!"
