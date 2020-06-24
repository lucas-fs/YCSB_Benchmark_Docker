#!/bin/bash

# workload from where data will be load
dataload=a

for replicas in 1 2 4 6
do
    for rcount in 1000000
    do  
        # rm cassandra stack
        echo "[Run Benchmark] Removing cassandra stack..."
        docker stack rm cassandra 

        # clear cassandra diretories
        echo "[Run Benchmark] Cleaning up cassandra storage directories..."
        ~/pi-cluster/cls_cassandra.sh
        
        # sleep 2 min
        echo "[Run Benchmark] Pause to stabilize cluster..."
        sleep 120

        echo "[Run Benchmark] Deploy new cassandra stack with $replicas replicas..."
        if [ $replicas -eq 1 ]        
        then
            # deploy cassandra stack
            docker stack deploy -c docker-compose-seed.yml cassandra

        elif [ $replicas -eq 2 ]
        then
            # deploy cassandra stack
            docker stack deploy -c docker-compose.yml cassandra

        else
            # deploy cassandra stack
            docker stack deploy -c docker-compose.yml cassandra
            # scale cassandra stack
            echo "[Run Benchmark] Scaling cassandra nodes..."
            docker service scale cassandra_node=$(($replicas-1))
        fi
        # wait until cluster stabilizes
        echo "[Run Benchmark] Waiting until cluster state stabilizes..."
        sleep $((($taskwait * $replicas) + 60))
        
        # run load script on container
        echo "[Run Benchmark] Executing load script..."
        docker container exec ycsb ./load.sh $dataload $rcount $replicas
        echo "[Run Benchmark] Pause to stabilize cluster..."
        sleep 60

        for wload in a b c d
        do
            echo "[Run Benchmark] Executing the run script for workload ( $wload )..."
            docker container exec ycsb ./execute.sh $dataload $rcount $replicas        
            echo "[Run Benchmark] Pause to stabilize cluster..."
            sleep 60
        done
    done
done