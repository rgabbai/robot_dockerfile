#!/bin/bash

set -e

source /opt/ros/foxy/setup.bash
cd repos/robot_ws
colcon build --symlink-install
source ./install/setup.bash
sudo chmod 666 /dev/Arduino_UNO


echo "Provided arguments $@"
exec $@
