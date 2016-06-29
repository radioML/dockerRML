FROM ubuntu:16.04
MAINTAINER Tim O'Shea <tim.oshea753@gmail.com>

# update repos/ppas...
RUN apt-get update 
RUN apt-add-repository -y ppa:x2go/stable
RUN apt-get install -y python-software-properties software-properties-common
RUN apt-get update 

# install core packages
RUN apt-get install -y python-pip git openssh-server vim emacs meld 
RUN apt-get install -y python-matplotlib python-scipy python-numpy
RUN apt-get install -y python-sklearn python-sklearn-doc python-skimage python-skimage-doc python-scikits-learn python-scikits.statsmodels

# set up remove visual login packages ...
RUN apt-get install xfwm4 xfce4 x2goserver x2goserver-xsession

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



