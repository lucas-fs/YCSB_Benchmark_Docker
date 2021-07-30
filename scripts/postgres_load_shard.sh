#!/bin/bash

node_ip=$1
workload=$2
recordcount=$3
replicas=$4
b_size=$5
f_size=$6

db_conf="# Properties file that contains database connection information.
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://$node_ip:5432/ycsb?reWriteBatchedInserts=true
db.user=postgres
db.passwd=postgres
db.batchsize=$b_size
jdbc.fetchsize=$f_size
jdbc.batchupdateapi=true
"

rm $JDBC_HOME/conf/db.properties
echo -e "$db_conf" > $JDBC_HOME/conf/db.properties

echo "[LOAD Script] Call shard_table.sh script to create usertable sharded"
/scripts/shard_table.sh postgres postgres $node_ip $replicas
sleep 300

echo "[LOAD Script] Performing load..."
$YCSB_HOME/bin/ycsb load jdbc -s -P $YCSB_HOME/workloads/workload$workload -P $JDBC_HOME/conf/db.properties -cp $CLASSPATH -p recordcount=$recordcount -p operationcount=10000 > /ycsb_output/out-load-$replicas-$recordcount-$workload-$b_size.txt 2>&1

chmod 777 /ycsb_output/out-load-$replicas-$recordcount-$workload-$b_size.txt

echo "[LOAD Script] Load finished!"