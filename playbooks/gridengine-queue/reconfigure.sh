
# create hostgroups
SLOT_CONFIG="1,"
rm -f $HOME/procs/my-hostgroups.txt
cd $HOME/procs
touch my-hostgroups.txt
for f in *.proc; do
  echo "Processing hostgroup from $f"
  group_name=$(basename "$f")
  n_proc="${group_name%.*}"
  echo "group_name @$group_name" >> my-hostgroups.txt
  hosts=`cat $f`	  
  echo "hostlist $hosts" >> my-hostgroups.txt
  SLOT_CONFIG="${SLOT_CONFIG}[@$group_name=$n_proc],"
done

echo "slot config: ${SLOT_CONFIG::-1}"
#add hostgroups
sudo qconf -Ahgrp $HOME/procs/my-hostgroup.txt

#reconfigure the queue
qconf -sq all.q > new_queue_config
sed -i 's#/bin/csh#/bin/bash#g' new_queue_config
sed -i 's#/tmp#/scratch#g' new_queue_config
sed -i 's#slots *.*#slots      ${SLOT_CONFIG::-1} #g' new_queue_config
sudo qconf -Mq new_queue_config

