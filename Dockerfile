FROM ros:foxy
COPY config/ /my_config/

#General Install section
RUN apt-get update && apt-get install -y  \ 
    nano \  
    vim  \  
    less \
&& rm -rf /var/lib/apt/lists/*

# ROS specific install section
RUN apt-get update && apt-get install -y  \ 
 ros-dev-tools \
 ros-foxy-xacro \
 ros-foxy-twist-mux \
 ros-foxy-ros2-control \
 ros-foxy-ros2-controllers \
 ros-foxy-gazebo-ros2-control \
&& rm -rf /var/lib/apt/lists/*




# Define new user
ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

#create a non root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

#set up sudo
RUN apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL =\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*


COPY entrypoint.sh /entrypoint.sh
COPY bashrc /home/${USERNAME}/.bashrc
ENTRYPOINT ["/bin/bash", "entrypoint.sh"]

# no external cmd - just open bash terminal
CMD ["bash"]

# use ros as user 
#USER ros

# Change user to root for install
#USER root 