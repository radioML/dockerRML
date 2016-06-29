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
RUN apt-get install -y python-pip git openssh-server vim emacs meld 
RUN apt-get install -y python-matplotlib python-scipy python-numpy
RUN apt-get install -y python-sklearn python-sklearn-doc python-skimage python-skimage-doc python-scikits-learn python-scikits.statsmodels

# set up remove visual login packages ...
RUN apt-get install -y xfwm4 xfce4 x2goserver x2goserver-xsession

# install python packages
RUN pip install --upgrade pip
RUN pip install --upgrade ipython[all]
RUN pip install --upgrade --no-deps git+git://github.com/Theano/Theano.git
RUN pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.9.0-cp27-none-linux_x86_64.whl
RUN pip install --upgrade git+https://github.com/fchollet/keras.git

# check out sources
RUN cd /root/ && git clone https://github.com/Theano/Theano.git
RUN cd /root/ && git clone https://github.com/tensorflow/tensorflow.git
RUN cd /root/ && git clone https://github.com/fchollet/keras.git

# set up gnuradio and related tools
RUN apt-get install -y autotools-dev autoconf sudo wireshark
RUN pip install --upgrade git+https://github.com/gnuradio/pybombs.git
RUN cd /gr/ && pybombs prefix init .
RUN cd /gr/ && pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git 
RUN cd /gr/ && pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
RUN cd /gr/ && pybombs install gnuradio gr-burst gr-pyqt gr-pcap gr-mapper gr-analysis 

# copy in some helpful files
COPY .vimrc /root/



