WORK_DIR=`pwd`

apt-get update

#install java 7 if needed
JAVA_VER=`java -version 2>&1 | grep "java version" | awk '{print $3}' | tr -d \" | awk '{split($0, array, ".")} END{print array[2]}'`
if [ "$JAVA_VER" -ge 7 ]; then
    echo "Java 7 or greater detected."
else
    echo "Java version is lower than 7."
    sudo apt-get -y install openjdk-7-jre-headless
fi

#install nextflow if needed
cd $HOME
if [ ! -d nextflow/ ]; then
	mkdir -p nextflow
	cd nextflow/
	curl -fsSL get.nextflow.io | bash
else
	echo "Nexflow is already installed."
fi

#add to PATH
echo "export PATH=$HOME/nextflow:$PATH" >> $HOME/.bashrc

#docker
apt-get -y install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get purge lxc-docker
apt-cache policy docker-engine
sudo apt-get install linux-image-generic-lts-trusty
sudo reboot
sudo apt-get install docker-engine
sudo service docker start
cd $WORK_DIR
