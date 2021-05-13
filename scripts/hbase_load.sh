#!/bin/bash

node_ip=$1
workload=$2
recordcount=$3
replicas=$4


# Define aux var to splits count (10*regionservers number)
echo "n_splits = 140" | hbase shell -n
status_code=$?
if [ ${status_code} -ne 0 ]; then
  echo "Define n_splits failed! status: ${status_code}"
fi

# Create Table
echo -e "create 'usertable', 
        'family', {SPLITS => (1..n_splits).map 
                {|i| \"user#{1000+i*(9999-1000)/n_splits}\"}}" | hbase shell -n
status_code=$?
if [ ${status_code} -ne 0 ]; then
  echo "Create table failed! status: ${status_code}"
fi

# Wait for cluster stabilizes
sleep 120

# Perform YCSB Load
echo "[LOAD Script] Performing load..."

ycsb load hbase2 -s \
-P $YCSB_HOME/workloads/workload$workload \
-cp /HBASE-HOME/conf \
-p table=usertable \
-p columnfamily=family \
-p recordcount=$recordcount \
-p operationcount=10000 \
> /ycsb_outputs/hbase-out-load-$replicas-$recordcount-$workload.txt 2>&1

chmod 777 /ycsb_outputs/hbase-out-load-$replicas-$recordcount-$workload.txt

echo "[Load Script] Load finished!"
