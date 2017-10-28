#!/bin/bash

# Fetch the variables
. parm.txt

# function to get the current time formatted
currentTime()
{
  date +"%Y-%m-%d %H:%M:%S";
}

sudo docker service scale devops-bookstack=0
sudo docker service scale devops-bookstackdb=0

echo ---$(currentTime)---populate the volumes---
#to zip, use: sudo tar zcvf devops_bookstack_volume.tar.gz /var/nfs/volumes/devops_bookstack*
sudo tar zxvf devops_bookstack_volume.tar.gz -C /



echo ---$(currentTime)---create bookstack database service---
sudo docker service create -d \
--name devops-bookstackdb \
--mount type=volume,source=devops_bookstackdb_volume,destination=/var/lib/mysql,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_bookstackdb_volume \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$BOOKSTACKDB_IMAGE

echo ---$(currentTime)---create bookstack service---
sudo docker service create -d \
--publish $BOOKSTACK_PORT:80 \
--name devops-bookstack \
--mount type=volume,source=devops_bookstack_volume_images,destination=/var/www/bookstack/public/uploads,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_bookstack_volume_images \
--mount type=volume,source=devops_bookstack_volume_attachments,destination=/var/www/bookstack/storage/uploads,\
volume-driver=local-persist,volume-opt=mountpoint=/var/nfs/volumes/devops_bookstack_volume_attachments \
--network $NETWORK_NAME \
--replicas 1 \
--constraint 'node.role == manager' \
$BOOKSTACK_IMAGE

sudo docker service scale devops-bookstackdb=1
sudo docker service scale devops-bookstack=1
