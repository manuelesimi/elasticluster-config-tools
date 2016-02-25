NAME=gridengine
SCRIPTS_DIR=/home/ubuntu/scripts
elasticluster start $NAME


for host in `elasticluster list-nodes gridengine | grep "  -" | cut -d'-' -f2`; do
  echo "installing packages on $host"

elasticluster sftp $NAME -n $host << EOF
   mkdir -p $SCRIPTS_DIR
   put install_packages.sh $SCRIPTS_DIR
EOF

elasticluster ssh $NAME -n $host << EOF2
   source $SCRIPTS_DIR/install_packages.sh
EOF2 

done
