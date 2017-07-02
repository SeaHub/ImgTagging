# coding: utf-8

import numpy as np
import sys
import os
sys.path.append("/home/wwwroot/cifar/public/cifar/caffe/python")
sys.path.append("/home/wwwroot/cifar/public/cifar/caffe/python/caffe")
import caffe

def writ(string):
    with open('/home/wwwroot/cifar/public/cifar/ans.txt','w') as f:
        for s in string:
            print s
            f.write(s+'\n')
        f.close()

def main(filepath):
    caffe_root = '/home/wwwroot/cifar/public/cifar/caffe/'
    
    sys.path.insert(0, caffe_root + 'python')
    os.chdir(caffe_root)

    MAX = 0
    for r,d,fs in os.walk(caffe_root + 'examples/alexnet_my/snapshot'):
        for f in fs:
            cnt = int((f.split('.')[0]).split('_')[2])
            if cnt > MAX:
                MAX = cnt
    print MAX
        
    net_file=caffe_root + 'examples/alexnet_my/deploy.prototxt'
    caffe_model=caffe_root + 'examples/alexnet_my/snapshot/mycaffe_iter_' + str(MAX) + '.caffemodel'
    mean_file=caffe_root + 'examples/alexnet_my/mean.npy'
    net = caffe.Net(net_file,caffe_model,caffe.TEST)
    transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
    transformer.set_transpose('data', (2,0,1))
    transformer.set_mean('data', np.load(mean_file).mean(1).mean(1))
    transformer.set_raw_scale('data', 255) 
    transformer.set_channel_swap('data', (2,1,0))
#    im=caffe.io.load_image('/home/jiamingmai/Desktop/test1/img3.png')
    im=caffe.io.load_image(filepath)
    net.blobs['data'].data[...] = transformer.preprocess('data',im)
    out = net.forward()
    imagenet_labels_filename = caffe_root + 'examples/alexnet_my/label.txt'
    labels = np.loadtxt(imagenet_labels_filename, str, delimiter='\t')
    top_k = net.blobs['loss'].data[0].flatten().argsort()[-1:-6:-1]

    ans = []
    for i in np.arange(top_k.size):
#        print top_k[i]
#        print labels[top_k[i]]
        strings = str(top_k[i]) + ' ' + str(labels[top_k[i]])
        ans.append(strings)
    writ(ans)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print 'input the path of photo'
    else :
        main(sys.argv[1])
