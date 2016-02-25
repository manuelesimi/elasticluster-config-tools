WORK_DIR=`pwd`

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

cd $WORK_DIR
