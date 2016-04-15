
The script use for sync hbase(0.98) table from source cluster to destination cluster

Prepare: 

  1. Setup hdfs account passwordless login from SRCHOST to DST which should specific in script.
  2. Please modify DEST-NAMENODE-IP  as real destination IP
  3. Run this script on SRCHOST(one node of source cluster) as hdfs account

RUN:

  bash -x hbase-table-sync.sh
