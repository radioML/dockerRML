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
RUN apt-get install -y python-sklearn python-sklearn-doc python-skimage python-skimage-doc python-scikits-learn python-scikits.statsmodels

# Set up remove login info
RUN mkdir /var/run/sshd
RUN echo 'root:radioml' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# somewhat more graphical packages..
RUN apt-get install -y python-opencv gimp 
RUN apt-get install -y firefox evince audacity meld

# set up remove visual login packages ...
RUN apt-get install -y xfwm4 xfce4 x2goserver x2goserver-xsession

# install python packages
RUN pip install --upgrade pip
RUN pip install --upgrade ipython[all]
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
RUN pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.9.0-cp27-none-linux_x86_64.whl
RUN pip install --upgrade git+https://github.com/fchollet/keras.git
RUN pip install --upgrade seaborn tqdm
RUN pip install --upgrade pandas

# set up gnuradio and related tools
RUN apt-get install -y sudo

# check out sources for reference
RUN mkdir /root/src/
RUN cd /root/src/ && git clone https://github.com/Theano/Theano.git
RUN cd /root/src/ && git clone https://github.com/tensorflow/tensorflow.git
RUN cd /root/src/ && git clone https://github.com/fchollet/keras.git

# Build PyOpenPNL and Gym deps
RUN pip install networkx
RUN apt-get install -y python-numpy python-dev cmake zlib1g-dev libjpeg-dev xvfb libav-tools xorg-dev python-opengl libboost-all-dev libsdl2-dev swig pypy-dev automake autoconf libtool
RUN cd /root/src/ && git clone https://github.com/PyOpenPNL/OpenPNL.git && cd OpenPNL && ./autogen.sh &&  ./configure CFLAGS='-g -O2 -fpermissive -w' CXXFLAGS='-g -O2 -fpermissive -w' && make -j4 && make install
RUN cd /root/src/ && git clone https://github.com/PyOpenPNL/PyOpenPNL.git && cd PyOpenPNL && python setup.py build && python setup.py install
RUN cd /root/src/ && git clone https://github.com/osh/kerlym.git && cd kerlym && python setup.py build && python setup.py install

# set up OpenAI Gym
RUN cd /root/src/ && git clone https://github.com/openai/gym.git && cd gym && pip install -e .
RUN pip install gym[atari] pachi_py
RUN mkdir /root/src/notebooks/

# copy in some helpful files / set up env on login
COPY .vimrc /root/

# generate jupyter config
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.token = u''" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '*'" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8888" >> ~/.jupyter/jupyter_notebook_config.py
