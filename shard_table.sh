#!/bin/bash

#  ____________________________________________________________________________
# |                                   TODO                                     |
# |                                                                            |
# | 1 - drop e create table usertable do ycsb com particionamento por hash;    |
# | 2 - criar partition table no master                                        |    
# | 3 - criar patition tables nos nós de shard                                 |
# | 4 - criar foreign tables para todos os servidores de shard no server master|
# | 5 - load ycsb                                                              |
# |____________________________________________________________________________|
#

execute_query(){
    local query=$1
    local host=$2
    
    PGPASSWORD=$PG_PASS psql -h $host \
                             -U $PG_USER \
                             -d $DATABASE \
                             -c "$query"
}

PG_USER=$1
PG_PASS=$2
MASTER_IP=$3
NODE_COUNT=$4

DATABASE="ycsb"
TABLE_NAME="usertable"
SHARD_SERVICE="shard"

SQL_DROP="DROP TABLE IF EXISTS $TABLE_NAME;"

SQL_CREATE_TABLE="\
    CREATE TABLE $TABLE_NAME(
    YCSB_KEY VARCHAR (255) PRIMARY KEY,
    FIELD0 TEXT, FIELD1 TEXT,
    FIELD2 TEXT, FIELD3 TEXT,
    FIELD4 TEXT, FIELD5 TEXT,
    FIELD6 TEXT, FIELD7 TEXT,
    FIELD8 TEXT, FIELD9 TEXT) 
    PARTITION BY HASH (YCSB_KEY);"


MASTER_SHARD_NAME=$TABLE_NAME"_shard_00"
SQL_MASTER_SHARD="\
    CREATE TABLE $MASTER_SHARD_NAME 
    PARTITION OF $TABLE_NAME 
    FOR VALUES WITH (modulus $NODE_COUNT, remainder 0));"

# Drop usertable if exists
execute_query $SQL_DROP $MASTER_IP

# Create patitioned usertable
execute_query $SQL_CREATE_TABLE $MASTER_IP

# Create Master shard
execute_query $SQL_MASTER_SHARD $MASTER_IP

tasks_ips=( `getent hosts tasks.$SHARD_SERVICE | awk '{print $1}'` )

shard_n=0
for ip in "${tasks_ips[@]}"
do
    ((shard_n++))
    shard=$(printf %02d $shard_n)

    NODE_SHARD_NAME=$TABLE_NAME"_shard_"$shard
    SQL_NODE_SHARD="\
        CREATE TABLE $NODE_SHARD_NAME(
        YCSB_KEY VARCHAR (255) PRIMARY KEY,
        FIELD0 TEXT, FIELD1 TEXT,
        FIELD2 TEXT, FIELD3 TEXT,
        FIELD4 TEXT, FIELD5 TEXT,
        FIELD6 TEXT, FIELD7 TEXT,
        FIELD8 TEXT, FIELD9 TEXT);"

    execute_query $SQL_NODE_SHARD $ip
    
    SQL_FOREIGN_TABLE="\
        CREATE FOREIGN TABLE $NODE_SHARD_NAME 
        PARTITION OF $TABLE_NAME 
        FOR VALUES WITH (modulus $NODE_COUNT, remainder $shard_n) 
        SERVER shard_$shard;"

    execute_query $SQL_FOREIGN_TABLE $MASTER_IP

done


