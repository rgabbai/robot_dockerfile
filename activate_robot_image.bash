sudo docker run -it --privileged  --rm --network=host  --ipc=host  -v $PWD/my_repos:/repos \
        -v /dev:/dev \
robot
