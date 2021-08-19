CREATE EXTENSION postgres_fdw;

CREATE SERVER data_node_0 
FOREIGN DATA WRAPPER postgres_fdw 
OPTIONS (
    host '10.10.0.1',
    port '5432',
    dbname 'tpc_h',
    use_remote_estimate 'TRUE',
    fetch_size '100000'
);

CREATE SERVER data_node_3 
FOREIGN DATA WRAPPER postgres_fdw 
OPTIONS (
    host '10.10.0.2',
    port '5432',
    dbname 'tpc_h',
    use_remote_estimate 'TRUE',
    fetch_size '100000'
);

CREATE TABLE lineitem (
    l_orderkey BIGINT NOT NULL,
    l_partkey INT NOT NULL,
) PARTITION BY HASH (l_orderkey);

CREATE FOREIGN TABLE lineitem_shard_0 
PARTITION OF lineitem 
FOR VALUES WITH (MODULUS 4, REMAINDER 0) 
SERVER data_node_0 OPTIONS(table_name 'lineitem');


CREATE FOREIGN TABLE lineitem_shard_3 
PARTITION OF lineitem 
FOR VALUES WITH (MODULUS 4, REMAINDER 3) 
SERVER data_node_3 OPTIONS(table_name 'lineitem');