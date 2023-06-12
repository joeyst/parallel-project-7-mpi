#!/bin/bash

module load openmpi
mpic++ fourier.cpp -o fourier -lm
mpiexec -np 4 fourier