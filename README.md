# robot_dockerfile
This Repo holds all required file to setup ros2 foxy env with my robot

The docker directroy setup 
prepare the following dir
/home/linaro/projects/my_robot
/home/linaro/projects/my_robot/my_repos/robot_ws/src

clone robot_dockerfile repo under my_robot

Note actual package repoes need to be cloned in advance under robot_ws/src:
joy_to_array_topic
serial
teleop_twist_joy

# Running docker

move to my_robot

./robot_dockerfile/run_docker.bash 

# Inside docker
launch launch/joy-launch.py




