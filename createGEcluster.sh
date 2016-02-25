#!/bin/bash

NAME=gridengine
SCRIPTS_DIR=/home/ubuntu/config-tools

# create the GE cluster on the cloud platform
#elasticluster start $NAME

first=yes
for host in `elasticluster list-nodes gridengine | grep "  -" | cut -d'-' -f2`; do
echo "installing packages on $host"

#since the home folder is shared among the nodes, we upload the script only once
if [ "$first" == "yes" ]; then
elasticluster sftp $NAME -n $host << EOF
mkdir $SCRIPTS_DIR
put install_packages.sh $SCRIPTS_DIR
EOF
first=no
fi

#install the packages on the node
elasticluster ssh $NAME -n $host << END
source $SCRIPTS_DIR/install_packages.sh
END

done
