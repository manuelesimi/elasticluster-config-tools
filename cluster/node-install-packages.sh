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

# Docker installtion
sudo apt-get -y install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Add the repository to your APT sources
echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" > docker.list && sudo mv docker.list /etc/apt/sources.list.d/
sudo apt-get update
apt-cache policy docker-engine

# Install docker and start
sudo apt-get -y install docker-engine
sudo service docker start

# Test the installation
sudo docker run hello-world

cd $WORK_DIR
