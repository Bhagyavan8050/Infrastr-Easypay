#!/bin/bash
# Run on master
TIMESTAMP=$(date +%F_%T)
ETCD_BACKUP="/tmp/etcd_backup_$TIMESTAMP.db"
sudo ETCDCTL_API=3 etcdctl snapshot save $ETCD_BACKUP --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key
echo "Saved etcd snapshot: $ETCD_BACKUP"