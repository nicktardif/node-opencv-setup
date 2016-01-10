#This file describes how to build node-opencv into a runnable linux container with all dependencies installed
# To build:
# 1) Install docker (http://docker.io)
# 2) Build: wget https://raw.github.com/dotcloud/docker/v0.1.6/contrib/docker-build/docker-build && python docker-build $USER/node-opencv < Dockerfile
# 3) Test: docker run $USER/node-opencv node -e "console.log(require('opencv').version)"
#
# VERSION   0.2
# DOCKER-VERSION  8.1.2

# update to 14.04
FROM ubuntu:14.04
RUN apt-get update -qq && apt-get install -y \
  software-properties-common \
  python-software-properties \
  curl
RUN add-apt-repository -y ppa:kubuntu-ppa/backports
RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN apt-get update && apt-get install -y \
  libcv-dev \
  libcvaux-dev \
  libhighgui-dev \
  libopencv-dev \
  nodejs

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer

# Nick stuff
RUN sudo apt-get install -y \
  vlc \
  feh \
  toilet \
  git \
  vim

# C-C-C-Cache Buster!!!
ADD version version
RUN rm version

RUN git clone https://github.com/nicktardif/dotfiles.git
RUN cd dotfiles && ./install.sh

RUN git clone https://github.com/peterbraden/node-opencv.git && \
    cd node-opencv && \
    npm install

CMD ["/bin/bash"]
