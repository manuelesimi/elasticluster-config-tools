WORK_DIR=`pwd`

sudo apt-get update

#install java 7 if needed
JAVA_VER=`java -version 2>&1 | grep "java version" | awk '{print $3}' | tr -d \" | awk '{split($0, array, ".")} END{print array[2]}'`
if [ "$JAVA_VER" -ge 7 ]; then
    echo "Java 7 or greater detected."
else
    echo "Java version is lower than 7."
    sudo apt-get -y install openjdk-7-jre-headless
fi

#install nextflow 
cd $HOME
mkdir -p nextflow
cd nextflow/
curl -fsSL get.nextflow.io | bash
#add to PATH
echo "export PATH=$HOME/nextflow:$PATH" >> $HOME/.bashrc
echo "export PATH=$HOME/nextflow:$PATH" >> $HOME/.bash_profile
# install docker if needed
if [ -z `which docker` ]; then
	sudo apt-get -y install apt-transport-https ca-certificates
	sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	# Add the repository to your APT sources
	echo "deb https://apt.dockerproject.org/repo ubuntu-precise main" > docker.list && sudo mv docker.list /etc/apt/sources.list.d/
	sudo apt-get update
	apt-cache policy docker-engine

	# Install docker and start the daemon
	sudo apt-get -y install docker-engine
	sudo service docker start
	
	#create the docker group and add the ubuntu user. This avoids to have to use sudo in all the docker commands. Nextflow won't work without this setting.
	sudo usermod -aG docker ubuntu	
	
	#restart docker daemon to check if it works properly
	#sudo restart docker
else 
	echo "Docker is already installed on this machine."
fi

# Test the installation
sudo docker run hello-world

cd $WORK_DIR
