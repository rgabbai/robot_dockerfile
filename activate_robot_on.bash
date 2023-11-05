sudo docker run -e ROBOT_ON=1 -it  --network=host  --ipc=host  -v $PWD/my_repos:/repos  --device=/dev/video5  --device=/dev/Arduino_UNO my_robot
