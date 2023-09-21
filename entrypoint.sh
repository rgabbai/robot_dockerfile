#!/bin/bash

set -e
# Build ROS WS
#=======================================
source /opt/ros/foxy/setup.bash
cd repos/robot_ws
colcon build --symlink-install
source ./install/setup.bash
sudo chmod 666 /dev/Arduino_UNO

# teleop_twist_Joy
cd src/teleop_twist_joy
colcon build --symlink-install
source ./install/setup.bash

# joy to array topic node
cd ../joy_to_array_topic/
colcon build --symlink-install
source ./install/setup.bash

#serial HW interface for Arduino
cd ../serial
colcon build --symlink-install
source ./install/setup.bash


cd ../../
echo "Provided arguments $@"
exec $@
