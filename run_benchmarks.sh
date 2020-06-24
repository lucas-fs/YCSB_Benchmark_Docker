#!/bin/bash

nodes=$1

recreate_keyspace() {
    echo "Drop keyspace"
    cqlsh 15.0.0.1 -p9042 --cqlversion=3.4.4 -e "DROP keyspace IF EXISTS ycsb;"
    echo "Recreate keyspace"
    cqlsh 15.0.0.1 -p9042 --cqlversion=3.4.4 -e "create keyspace ycsb
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
}

prepare_stack() {

# rm cassandra stack
# clear cassandra diretories
# sleep 1 min
# deploy cassandra stack
# scale cassandra stack
# sleep (taskwait * replicas) + taskwait

}


# recordcount incrementation
for rcount in 1000 5000 10000 50000
do  
    prepare_stack    
    # run load script on container
     
    for wload in a b c d e
    do
        # run workload script on container        
    done

done




















