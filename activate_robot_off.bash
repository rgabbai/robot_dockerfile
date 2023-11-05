sudo docker run -it  --network=host  --ipc=host  -v $PWD/my_repos:/repos  --device=/dev/video5  --device=/dev/Arduino_UNO my_robot
