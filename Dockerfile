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
RUN apt-get update &&  \
    apt-get install -y python-pip git openssh-server vim emacs screen tmux locate \
    	    	       python-matplotlib python-scipy python-numpy \
                       python-sklearn python-sklearn-doc python-skimage \
                       python-skimage-doc python-scikits-learn python-scikits.statsmodels \
		       python-opencv gimp \
		       firefox evince audacity meld \
		       xfwm4 xfce4 x2goserver x2goserver-xsession \
		       autotools-dev autoconf sudo wireshark gdb
		       

# Set up remove login info
RUN mkdir /var/run/sshd
RUN echo 'root:radioml' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#
# Add interactive user for x2go
#
RUN adduser --gecos "X2Go User" --disabled-password x2go
RUN echo "x2go:x2go" | chpasswd
RUN mkdir -p /home/x2go/.jupyter /home/x2go/mnt
COPY imagefiles-jupyter /home/x2go/.jupyter
COPY imagefiles-sudo /etc/sudoers.d
COPY .vimrc /home/x2go/
RUN echo "source /gr/setup_env.sh" >> /home/x2go/.bashrc

VOLUME /home/x2go/mnt

# install python packages
RUN pip install --upgrade pip
RUN pip install --upgrade ipython[all]
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
RUN pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.9.0-cp27-none-linux_x86_64.whl
RUN pip install --upgrade git+https://github.com/fchollet/keras.git
RUN pip install --upgrade seaborn tqdm
RUN pip install --upgrade pandas

# set up gnuradio and related tools
RUN pip install --upgrade git+https://github.com/gnuradio/pybombs.git
RUN mkdir /gr/
RUN cd /gr/ && pybombs prefix init .
RUN cd /gr/ && pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git 
RUN cd /gr/ && pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
RUN cd /gr/ && pybombs install gnuradio gr-burst gr-pyqt gr-pcap gr-mapper gr-analysis 

# check out sources for reference
RUN /bin/ln -s /gr/src/ /home/x2go/src
RUN cd /home/x2go/src/ && git clone https://github.com/Theano/Theano.git
RUN cd /home/x2go/src/ && git clone https://github.com/tensorflow/tensorflow.git
RUN cd /home/x2go/src/ && git clone https://github.com/fchollet/keras.git

# Build PyOpenPNL and Gym deps
RUN pip install networkx
RUN apt-get install -y python-numpy python-dev cmake zlib1g-dev libjpeg-dev xvfb libav-tools xorg-dev python-opengl libboost-all-dev libsdl2-dev swig pypy-dev
RUN cd /home/x2go/src/ && git clone https://github.com/PyOpenPNL/OpenPNL.git && cd OpenPNL && ./autogen.sh &&  ./configure CFLAGS='-g -O2 -fpermissive -w' CXXFLAGS='-g -O2 -fpermissive -w' && make -j4 && make install
RUN cd /home/x2go/src/ && git clone https://github.com/PyOpenPNL/PyOpenPNL.git && cd PyOpenPNL && python setup.py build && python setup.py install
RUN cd /home/x2go/src/ && git clone https://github.com/osh/kerlym.git && cd kerlym && python setup.py build && python setup.py install

# set up OpenAI Gym
RUN cd /home/x2go/src/ && git clone https://github.com/openai/gym.git && cd gym && pip install -e .
RUN pip install gym[atari] pachi_py
RUN mkdir /home/x2go/src/notebooks/


WORKDIR /home/x2go
# copy in some helpful files / set up env on login
COPY .vimrc /home/x2go/
RUN echo "source /gr/setup_env.sh" >> /home/x2go/.bashrc

RUN apt-get install -y supervisor
COPY imagefiles-supervisord /etc/supervisor/conf.d

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN chown -R x2go /home/x2go

EXPOSE 22 8888
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf", "-n"]
