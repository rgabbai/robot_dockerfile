#!/bin/bash

set -e
# Build ROS WS
#=======================================
source /opt/ros/foxy/setup.bash
cd repos/robot_ws
colcon build --symlink-install
source ./install/setup.bash


# Enable Arduino_uno device if file exist
echo "Checking if Arduino connected and enable R/W"
FILE=/dev/Arduino_UNO
if stat "$FILE" &> /dev/null; then
    echo "$FILE exists."
    sudo chmod 666 $FILE
else 
    echo "Warning: $FILE does not exist."
fi

echo "checking if XBOX connected and enable R/W"
FILE=/dev/input/by-id/usb-Microsoft_Controller_3033363030313330363632363334-event-joystick
if stat "$FILE" &> /dev/null; then
    echo "$FILE exists."
    sudo chmod 666 $FILE
else 
    echo "Warning: $FILE does not exist."
fi

FILE=/dev/input/event3
if stat "$FILE" &> /dev/null; then
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

# Arduino - diffdrive_arduino
cd ../diffdrive_arduino
colcon build --symlink-install
source ./install/setup.bash


# back to root.
cd ../../

# Temp fix for usb camera file name
cd /dev
ln -s video5 video0
cd - 
# PATH: robot_ws

if [[ -z "${ROBOT_ON}" ]]; then
  echo "ROBOT_ON is not set $ROBOT_ON"
else
  echo "Activating Robot SW"

    # Activating Robot ROS control
    #=============================
    source install/setup.bash
    ros2 launch poc_2W_Robot launch_robot2.launch.py &

    # Activating detection pipe
    #==============================
    # Copy onnx run time to usr/lib
    cp libonnxruntime.so.1.15.1 /usr/lib/.

    cd ../cam_det_pub_node/ #PATH: repos/cam_det_pub_node
    ./target/release/det_publisher 0.5 &
fi


echo "Provided arguments $@"
exec $@
