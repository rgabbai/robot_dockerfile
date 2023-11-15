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


# Below seperate compile not required as all compiled by robot_ws above
# teleop_twist_Joy
#----------------------------------------------------------------------------------
#cd src/teleop_twist_joy
#colcon build --symlink-install
#source ./install/setup.bash

# joy to array topic node
#cd ../joy_to_array_topic/
#colcon build --symlink-install
#source ./install/setup.bash

#serial HW interface for Arduino
#cd ../serial
#colcon build --symlink-install
#source ./install/setup.bash

# Arduino - diffdrive_arduino
#cd ../diffdrive_arduino
#colcon build --symlink-install
#source ./install/setup.bash

# Build realsense 
#cd  ../../../librealsense
#mkdir build
#cd build
#cmake ../ -DFORCE_RSUSB_BACKEND=ON -DBUILD_PYTHON_BINDINGS:bool=true -DPYTHON_EXECUTABLE=/usr/bin/python3.8 -DCMAKE_BUILD_TYPE=release -DBUILD_EXAMPLES=true -DBUILD_GRAPHICAL_EXAMPLES=false

# Lets not clean .. to save time sudo make uninstall && make clean && make && sudo make install
# make && sudo make install


# back to root. robot_ws
#cd ../../robot_ws
#---------------------------------------------------------------------------------


# Temp fix for usb camera file name for Asus - removed fixed in ros node instead
#cd /dev
#ln -s video5 video0
#cd -

#----------------
# PATH: /robot_ws/
#----------------
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
    # Copy onnx run time to usr/lib from robot_ws/
    cp libonnxruntime.so.1.15.1 /usr/lib/.

    # Compile:  
    # Enter /robot_ws/cam_det_pub_node
    #cd cam_det_pub_node
    # cargo update -p ort --precise 1.15.1
    # cargo build --release
    ## Run scheme at 0.5FPS 
    ../cam_det_pub_node/target/release/det_publisher 0.5

    # Activate MPU6050
    #======================
    ros2 run mpu6050 imu_publisher_node

    cd ../
fi


echo "Provided arguments $@"
exec $@
