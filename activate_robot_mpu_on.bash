sudo docker run -e ROBOT_ON=1 -it --rm --privileged --network=host  --ipc=host  -v $PWD/my_repos:/repos  -v /dev:/dev robot
