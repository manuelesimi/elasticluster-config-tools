NAME=gridengine
JOB_AREA=/home/ubuntu
DIR_TO_UPLOAD=$1
WORKFLOW_ID=$2
DEST_DIR=$JOB_AREA/$WORKFLOW_ID

echo "Uploading workflow files to ${DEST_DIR}..."
elasticluster ssh $NAME << MAKE
rm -rf $DEST_DIR
mkdir -p $DEST_DIR
MAKE

elasticluster sftp $NAME << PUT
put -r $1/* $DEST_DIR
PUT

echo Done
