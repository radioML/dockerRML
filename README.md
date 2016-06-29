
# RadioML Docker Image

A docker image provided by https://radioml.com/ which provides many of the primitives needed for radio machine learning experimentation.

## Docker Image Contents

 - *Base:*   Ubuntu 16.04 Xenial Xerus
 - *Remote:* ssh-server, x2go server + xfce4, ipython notebook
 - *Misc:*   screen, tmux, vim, emacs, git, meld
 - *DL:*     Theano, TensorFlow, Keras, OpenAI Gym, KeRLym
 - *ML:*     Scikit-learn, OpenCV, PyOpenPNL
 - *SDR:*    GNU Radio + several useful out-of-tree gr-modules

## Building the Container

```
git clone https://github.org/radioML/dockerRML.git rml
cd rml && sudo docker build -t radioml/radioml . 
```

This will take a while to build, so find something to do for an hour

## Running the Container

To launch in foreground terminal
```
docker run -i -t osh/testrml2 /bin/bash
```

To launch in background with ssh up (needed before x2go)
```
docker run -d -P --name test_rml radioml/radioml
docker port test_rml 22
docker port test_rml 8888
```

Connect with CLI
```
sudo docker exec -i -t test_rml /bin/bash
```
or
```
ssh root@`docker port test_rml 22`
# use password radioml
```

Connect with x2go (good way to run GRC)
```
docker port test_rml 22
x2goclient
# set ssh ip and port from docker, login with root/radioml, use xfce as window manager
```

Connect with iPython Notebook (good way to run python experiments)
```
sudo docker exec -i -t test_rml /bin/bash
screen
cd /root/src/notebooks/
ipython notebook
```
not open http://docker_ip:8888 in the host browser


## Notes

 - *GPU Support:* For the moment theano and tensorflow are installed without GPU support in this docker
 - *Image Size:* Current image size is ~10GB after build

