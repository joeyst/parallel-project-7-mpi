#!/bin/bash

for b in 1 2 4 8 16
do
        g++ -DMATW=$s -DLOCALSIZE=$b -o proj07_opencl proj07_opencl.cpp /usr/local/apps/cuda/cuda-10.1/lib64/libOpenCL.so.1.1 -lm -fopenmp
        ./proj07_opencl
done