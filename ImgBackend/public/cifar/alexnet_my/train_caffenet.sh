#!/usr/bin/env sh
set -e

/home/wwwroot/cifar/public/cifar/caffe/build/tools/caffe train \
    --solver=/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my/solver.prototxt $@
