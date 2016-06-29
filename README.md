
# RadioML Docker Image

A docker image provided by https://radioml.com/ which provides many of the primitives needed for radio machine learning experimentation.

## Docker Image Contents

 - Base:   Ubuntu 16.04 Xenial Xerus
 - Remote: ssh-server, x2go server + xfce4, ipython notebook
 - Misc:   screen, tmux, vim, emacs, git, meld
 - DL:     Theano, TensorFlow, Keras, OpenAI Gym, KeRLym
 - ML:     Scikit-learn, OpenCV, PyOpenPNL
 - SDR:    GNU Radio + several useful out-of-tree gr-modules

## Installation

```
git clone https://github.org/radioML/dockerRML.git rml
cd rml && sudo docker build -t radioml/radioml . 
```

## Running the Docker

To launch a terminal
```
docker run -i -t osh/testrml2 /bin/bash
```

TODO:
 - launching in background
 - ssh + x2go connection (for GRC etc)
 - ipython notebook connection 

## Notes

 - GPU Support: For the moment theano and tensorflow are installed without GPU support in this docker


