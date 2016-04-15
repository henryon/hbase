#!/bin/bash
#Version 0.0.1
#Author Henry Wen

#define temp file for store hbase table
LIST=./tablelist
DEST=DEST-NAMENODE-IP 

#define get all hbase table from source cluster
echo list|hbase shell  2>/dev/null|awk '/row/{A=0};A;/^ambar/{A=1};' > ${LIST}

#define the function of processing sync table from source cluster to destination cluster
proc() {
    table=$1
    echo 'delete current snapshot'
    echo "delete_snapshot  '${table}_snapshot' "|hbase shell

    echo 'create snapshot for per table'
    echo "snapshot '${table}' , '${table}_snapshot' "|hbase shell
    
    echo 'delete the snapshot on the destination cluster'
    ssh hdfs@${DEST}  "echo \"delete_snapshot '${table}_snapshot'\"|hbase shell"

    echo "export snapshot to destination cluster"
    hbase org.apache.hadoop.hbase.snapshot.ExportSnapshot -snapshot ${table}_snapshot -copy-to webhdfs://${DEST}:50070/apps/hbase/data -chuser hbase -chgroup hdfs -mappers 12
    
    echo "restore snapshot on destination cluster"
    ssh hdfs@${DEST}  "echo \"restore_snapshot '${table}_snapshot'\"|hbase shell"
}

for i in `cat ${LIST}`
  do proc $i

done

#clean temp file
rm -rf ${LIST}
