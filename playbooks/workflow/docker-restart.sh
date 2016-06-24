set -x
n=0
until [ "$n" -ge 5 ]
 do
        sudo restart docker
        output=`docker run artifacts/base:latest wget http://www.google.com 2>&1` 
        if [[ "$output" == *"failed"* ]]; then
                echo "Docker did not start properly! Trying to restart..."
                n=$[$n+1]
                sleep 3
        else
                echo "Docker network is working properly!"
                break
        fi                 
 done
set +x
