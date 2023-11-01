#!/bin/bash
JOY_XBOX_FILE=/dev/input/by-id/usb-Microsoft_Controller_3033363030313330363632363334-event-joystick
JOY_XBOX_EVENT=/dev/input/event3
ARDUINO_FILE=/dev/Arduino_UNO

echo "Activating docker container with my_robot image"

if stat "$JOY_XBOX_FILE" &> /dev/null; then
    echo "XBOX Joystic detected"
    if stat "$ARDUINO_FILE" &> /dev/null; then
      echo "Arduino Uno detected"
      sudo docker run -it --user ros --network=host  --ipc=host --device="$JOY_XBOX_FILE" --device="$JOY_XBOX_EVENT" --device="$ARDUINO_FILE" -v $PWD/my_repos:/repos my_robot
    else
      sudo docker run -it --user ros --network=host  --ipc=host --device="$JOY_XBOX_FILE" --device="$JOY_XBOX_EVENT" -v $PWD/my_repos:/repos my_robot
    fi
fi
