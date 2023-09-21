#!/bin/bash

set -e
# Build ROS WS
#=======================================
source /opt/ros/foxy/setup.bash
cd repos/robot_ws
colcon build --symlink-install
source ./install/setup.bash


# Enable Arduino_uno device if file exist
FILE=/dev/Arduino_UNO
if test -f "$FILE"; then
    echo "$FILE exists."
    sudo chmod 666 $FILE
else 
    echo "Warning: $FILE does not exist."
fi


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
