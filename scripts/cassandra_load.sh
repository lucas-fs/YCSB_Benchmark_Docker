#!/bin/bash

node_ip=$1
workload=$2
recordcount=$3
replicas=$4
rf=$5


echo "[LOAD Script] Dropping ycsb keyspace"
cqlsh $node_ip -p9042 --cqlversion=3.4.4 --connect-timeout=10 \
    -e "DROP keyspace IF EXISTS ycsb;"

sleep 10

echo "[LOAD Script] Recreating ycsb keyspace"
cqlsh $node_ip -p9042 --cqlversion=3.4.4 --connect-timeout=10 \
    -e "create keyspace ycsb
    WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': $rf }; 
    USE ycsb; 
    create table usertable (
    y_id varchar primary key,
    field0 varchar,
    field1 varchar,
    field2 varchar,
    field3 varchar,
    field4 varchar,
    field5 varchar,
    field6 varchar,
    field7 varchar,
    field8 varchar,
    field9 varchar);"

sleep 10

echo "[LOAD Script] Performing load..."

$YCSB_HOME/bin/ycsb load cassandra-cql -s \
-p hosts="$node_ip" \
-P $YCSB_HOME/workloads/workload$workload \
-p recordcount=$recordcount \
-p operationcount=10000 \
-p rectime=3000 \
-p cassandra.connecttimeoutmillis=60000 \
-p cassandra.readtimeoutmillis=60000 \
-p cassandra.readconsistencylevel=ONE \
-p cassandra.writeconsistencylevel=ONE \
-cp $CLASSPATH \
> /ycsb_outputs/out-load-$replicas-$recordcount-rf$rf-$workload.txt 2>&1

chmod 777 /ycsb_outputs/out-load-$replicas-$recordcount-rf$rf-$workload.txt

echo "[Load Script] Load finished!"
