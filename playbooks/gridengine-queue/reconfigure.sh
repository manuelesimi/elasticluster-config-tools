qconf -sq all.q > new_queue_config
sed -i 's#/bin/csh#/bin/bash#g' new_queue_config
sed -i 's#/tmp#/scratch#g' new_queue_config
sudo qconf -Mq new_queue_config
