FROM ubuntu:16.04
MAINTAINER Tim O'Shea <tim.oshea753@gmail.com>

# set up environment
ENV DEBIAN_FRONTEND noninteractive

# update repos/ppas...
RUN apt-get update 
RUN apt-get install -y python-software-properties software-properties-common
RUN apt-add-repository -y ppa:x2go/stable
RUN apt-get update 

# install core packages
RUN apt-get install -y python-pip git openssh-server vim emacs screen tmux locate
RUN apt-get install -y python-matplotlib python-scipy python-numpy
RUN apt-get install -y python-numpy python-dev

# Set up remove login info
RUN mkdir /var/run/sshd
RUN echo 'root:radioml' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# somewhat more graphical packages..
RUN apt-get install -y firefox evince audacity meld

# set up remove visual login packages ...
RUN apt-get install -y xfwm4 xfce4 x2goserver x2goserver-xsession

# install python packages
RUN pip install --upgrade pip

# set up gnuradio and related tools
RUN apt-get install -y autotools-dev autoconf sudo wireshark gdb
RUN pip install --upgrade git+https://github.com/gnuradio/pybombs.git
RUN mkdir /gr/
RUN cd /gr/ && pybombs prefix init .
RUN cd /gr/ && pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git 
RUN cd /gr/ && pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
RUN cd /gr/ && pybombs install gnuradio gr-burst gr-pyqt gr-pcap gr-mapper gr-analysis gr-mediatools

# check out sources for reference
RUN /bin/ln -s /gr/src/ /root/src

# copy in some helpful files / set up env on login
COPY .vimrc /root/
RUN echo "source /gr/setup_env.sh" >> /root/.bashrc



