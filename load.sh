#!/bin/bash

workload=$1
recordcount=$2

node_ip=`getent hosts tasks.seed | awk '{print $1}'| head -n 1`
echo "seed node ip: $node_ip"

echo "Drop keyspace"
cqlsh $node_ip -p9042 --cqlversion=3.4.4 -e "DROP keyspace IF EXISTS ycsb;"
echo "Recreate keyspace"
cqlsh $node_ip -p9042 --cqlversion=3.4.4 -e "create keyspace ycsb
        WITH REPLICATION = {'class' : 'SimpleStrategy', 'replication_factor': 3 }; 
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

ycsb load cassandra-cql -s -p hosts="$node_ip" -P $YCSB_HOME/workloads/workload$workload -p recordcount=$recordcount -cp $CLASSPATH
