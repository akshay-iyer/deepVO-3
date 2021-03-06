help:
	@cat Makefile

DATA?="/media/gpudata_backup/kitti/dataset/"
GPU?=0
KERAS-DOCKER-FILE=docker/keras_dockerfile
CAFFE-DOCKER-FILE=docker/caffe_dockerfile
DOCKER=GPU=$(GPU) nvidia-docker
BUILD-CONTEXT="docker/"
KERAS-BACKEND=tensorflow
SRC=$(shell pwd)
CAFFE-TAG="caffe-flownet"
KERAS-TAG="keras"

build-caffe:
	docker build -t $(CAFFE-TAG) -f $(CAFFE-DOCKER-FILE) $(BUILD-CONTEXT)

build-keras:
	docker build -t $(KERAS-TAG) -f $(KERAS-DOCKER-FILE) $(BUILD-CONTEXT)

caffe: build-caffe
	$(DOCKER) run --rm -it -v $(SRC):/workspace -v $(DATA):/workspace/data/dataset $(CAFFE-TAG) bash

keras: build-keras
	$(DOCKER) run --rm -it -v $(SRC):/workspace -v $(DATA):/workspace/data/dataset --env KERAS_BACKEND=$(KERAS-BACKEND) $(KERAS-TAG) bash

# Specify that no actual files are created from these make commands
.PHONY: build-caffe caffe build-keras keras
