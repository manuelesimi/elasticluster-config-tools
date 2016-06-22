
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
  #see http://arc.liv.ac.uk/SGE/howto/sge-configs.html#_slot_limits_a_id_slotlimit_a	
  sudo qconf -mattr exechost complex_values slots=$n_proc $hosts
done

echo "slot config: ${SLOT_CONFIG::-1}"
#add hostgroups
sudo qconf -Ahgrp $HOME/procs/my-hostgroups.txt

#reconfigure the queue
qconf -sq all.q > new_queue_config
sed -i 's#/bin/csh#/bin/bash#g' new_queue_config
sed -i 's#/tmp#/scratch#g' new_queue_config
sed -i "s#slots *.*#slots      ${SLOT_CONFIG::-1}#g" new_queue_config
sudo qconf -Mq new_queue_config

#reconfigure the complex configuration
qconf -sc > new_complex_config
echo "exclusive           excl       BOOL        EXCL    YES         YES        FALSE    0" >> new_complex_config
sudo qconf -Mc new_complex_config

#reconfigure memory on each host
cd $HOME/procs
for m in *.mem; do
  echo "Loading memory settings for $m"
  filename=$(basename "$m")
  hostname="${filename%.*}"
  mem=`cat $m`
  echo "Seting virtual_free to $mem for $hostname"
  sudo qconf -mattr exechost complex_values exclusive=true,virtual_free=$mem $hostname
done


