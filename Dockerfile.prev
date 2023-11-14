FROM ros:foxy
COPY config/ /my_config/

#General Install section
RUN apt-get update && apt-get install -y  \ 
    nano \  
    vim  \  
    less \
&& rm -rf /var/lib/apt/lists/*

#Sensors - Joystic,...
RUN apt-get update && apt-get install -y  \ 
    joystick \  
    xboxdrv  \  
&& rm -rf /var/lib/apt/lists/*

# ROS specific install section
RUN apt-get update && apt-get install -y  \ 
 ros-dev-tools \
 ros-foxy-xacro \
 ros-foxy-twist-mux \
 ros-foxy-ros2-control \
 ros-foxy-ros2-controllers \
 ros-foxy-gazebo-ros2-control \
 ros-foxy-joy \
&& rm -rf /var/lib/apt/lists/*

#Adding Rust dependecies 
# Get Ubuntu packages
RUN apt-get update && apt-get install -y -q \
    build-essential \
    curl

#Adding Camera required libs
RUN apt-get update && apt-get install -y  \
    libv4l-dev \
    libssl-dev


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


# RUST Install
# Get Rust; NOTE: using sh for better compatibility with other base images
RUN sudo chmod 777 /home/ros/.bashrc

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y 

# Add .cargo/bin to PAT
ENV PATH="/root/.cargo/bin:${PATH}"

# Check cargo is visible
#RUN cargo --help

# no external cmd - just open bash terminal
CMD ["bash"]

# use ros as user 
#USER ros

# Change user to root for install
#USER root 
