#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12

EXAMPLE=/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my
DATA=/home/wwwroot/cifar/public/cifar/caffe/examples/alexnet_my
TOOLS=/home/wwwroot/cifar/public/cifar/caffe/build/tools

$TOOLS/compute_image_mean $EXAMPLE/my1_train_lmdb \
  $DATA/mean.binaryproto

echo "create mean.binaryproto successfully Done."
echo "他妈的终于成功了，丢！！！"
