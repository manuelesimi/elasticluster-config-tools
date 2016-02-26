
NAME=gridengine
JOB_AREA=/home/ubuntu

elasticluster sftp $NAME  << EOF
put -r $1 $JOB_AREA
EOF
