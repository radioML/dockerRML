
# RadioML Docker Image

A simple docker image provided by https://radioml.com/ which provides many of the primitives needed for radio machine learning experementation.

## Docker Image Contents

 - Ubuntu 16.04
 - x2go server
 - ipython notebook
 - keras
 - theano
 - tensorflow
 - gnuradio
 - useful gnuradio OOT modules

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


