FROM dorowu/ubuntu-desktop-lxde-vnc:bionic-lxqt
MAINTAINER Truong Nghiem <truong.nghiem@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Add universe sources
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic-security main universe" >> /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu bionic-updates main universe" >> /etc/apt/sources.list

# Basic packages and useful tools
RUN apt-get update \
	&& apt-get install -y \
        build-essential python-pip python-dev python-vcstools \
		less tmux xterm unzip dirmngr gnupg2 lsb-release \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*

# --no-install-recommends --allow-unauthenticated \
#     && apt-get autoremove \
# apt-get above: libreoffice vlc flvstreamer ffmpeg emacs25

# Set up VLC under root
# RUN cp /usr/bin/vlc /usr/bin/vlc_backup
# RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc


# ===== bionic/ros-melodic install

# setup keys
RUN sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_DISTRO melodic

# install ROS
RUN apt-get update && apt-get install -y \
	ros-melodic-desktop-full \
	python-rosinstall python-rosinstall-generator python-wstool \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/*


# bootstrap rosdep
RUN rosdep init && rosdep update

# setup ROS workspace
RUN mkdir -p /home/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /home/catkin_ws/src; catkin_init_workspace'
RUN /bin/bash -c '. /opt/ros/melodic/setup.bash; cd /home/catkin_ws; catkin_make'

# Add ROS sourcing into .bashrc
RUN echo 'source "/opt/ros/$ROS_DISTRO/setup.bash"' >> /root/.bashrc
RUN echo 'source "/home/catkin_ws/devel/setup.bash"' >> /root/.bashrc


# Finish up
COPY image /

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]
