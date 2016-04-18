WORK_DIR=`pwd`

sudo apt-get update

#install java 8 if needed
JAVA_VER=`java -version 2>&1 | grep "java version" | awk '{print $3}' | tr -d \" | awk '{split($0, array, ".")} END{print array[2]}'`
if [ "$JAVA_VER" -ge 8 ]; then
    echo "Java 8 or greater detected."
else
    echo "Java version is lower than 8."
    sudo apt-get install -y python-software-properties debconf-utils
    sudo add-apt-repository -y ppa:webupd8team/java
    sudo apt-get update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
    sudo apt-get install -y oracle-java8-installer
fi

#install nextflow 
if [ -z `which nextflow`  ]; then
	sudo mkdir -p /nextflow && sudo chmod -R a+x+w+r /nextflow
	cd /nextflow
	curl -fsSL get.nextflow.io | bash
	#add to PATH
	echo "export PATH=/nextflow:$PATH" >> $HOME/.bashrc
	echo "export PATH=/nextflow:$PATH" >> $HOME/.bash_profile
	cd $HOME
else 
        echo "Nextflow is already installed on this machine."
fi

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
	sudo status docker
	echo "Restarting docker..."
	sudo start docker
	if [ $? -eq 0 ]
	then
  		echo "Docker successfully restarted."
	else
  		echo "Could not restart docker. Likely it is already running" >&2
	fi
else 
	echo "Docker is already installed on this machine."
fi

# Test the installation
sudo docker run hello-world

cd $WORK_DIR
