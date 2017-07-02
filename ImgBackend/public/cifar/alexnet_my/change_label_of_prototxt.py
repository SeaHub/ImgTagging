# coding=utf-8
'''
根据label.txt中的数量去更改deploy.prototxt和train_val.prototxt中的num_output参数
'''

import datetime
import numpy as np


if __name__ == '__main__':
    TIME = datetime.datetime.now()
    print 'run in ', TIME.strftime('%Y-%m-%D %H:%M:%S')
    LABELS = np.loadtxt('label.txt', str, delimiter='\t')
    LENGTH = len(LABELS)
    with open('deploy.prototxt', 'r') as f1, open('train_val.prototxt', 'r') as f2:
        STRINGS1 = f1.readlines()
        for i in xrange(len(STRINGS1)):
            if i == 224:
                STRINGS1[i] = STRINGS1[i][:16] + str(LENGTH) + '\n'
            #print STRINGS1[i]
        f1.close()
        STRINGS2 = f2.readlines()
        for i in xrange(len(STRINGS2)):
            if i == 249:
                STRINGS2[i] = STRINGS2[i][:16] + str(LENGTH) + '\n'
            #print STRINGS2[i]
        f2.close()
    with open('deploy.prototxt', 'w') as f1, open('train_val.prototxt', 'w') as f2:
        for s in STRINGS1:
            #print s
            f1.write(s)
        f1.close()
        for s in STRINGS2:
            #print s
            f2.write(s)
        f2.close()
