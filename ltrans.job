#!/bin/bash
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=2048
#SBATCH -t 11:30:00
#SBATCH --constraint=centos7
#SBATCH -p sched_mit_hill
#SBATCH -o jobname.job.%A.out
#SBATCH -e jobname.job.%A.err
filename=jobname


# This is a Job Script for Running LTRANS
# This should be placed in a directory which contains the LTRANS code and data

set -x

hostname
date


## Setting up directories ##
STORAGE_DIR="/home/$USER/${SLURM_JOB_ID}.${filename}"
mkdir -pv $STORAGE_DIR
#WORKING_DIR="/nobackup1c/users/$USER/foldername"
WORKING_DIR=$(pwd)
echo ">> These are the files that are in $WORKING_DIR << "
ls -l
##  Copying relavent files  ##
#cp $SLURM_SUBMIT_DIR/${filename}.${filetype} $STORAGE_DIR

module add singularity/3.2.1
singularity exec docker://ncolella/ltrans:latest cp /home/ltrans/LTRANSv2b/netcdf.inc $WORKING_DIR
singularity exec docker://ncolella/ltrans:latest cp /home/ltrans/LTRANSv2b/netcdf.mod $WORKING_DIR
singularity exec docker://ncolella/ltrans:latest cp /home/ltrans/LTRANSv2b/makefile $WORKING_DIR
singularity exec docker://ncolella/ltrans:latest make
singularity exec docker://ncolella/ltrans:latest ./LTRANS.exe

echo "VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV"
echo -n ">> Job finished @ "
date
echo ">> Output can be found in: $STORAGE_DIR"


