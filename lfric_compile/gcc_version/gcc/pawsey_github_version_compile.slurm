#!/bin/bash
#SBATCH --job-name=lfric_comp
#SBATCH --time=0:30:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1

#SBATCH --partition=debug

echo "Job started " $(date +"%T") 

# load correct modules 
#module use /software/projects/pawsey0835/ddeeptimahanti/modules
#module load lfric/cce/18.0.1
#module load  .py-psyclone/3.1.0-vlt43v4  # py-psyclone/3.2 does not work 
#module use /software/projects/pawsey0835/ddeeptimahanti/setonix/2025.04/modules/zen3/gcc/13.3.0/dependencies
#module use /software/projects/pawsey0835/ddeeptimahanti/setonix/2025.04/modules/zen3/gcc/13.3.0/astro-applications/
#module load .pfunit/4.10.0-twwu3qk
#module load .fcm/2021.05.0-65djiil

# GCC 
module use /software/setonix/2025.08/modules/zen3/gcc/14.2.0/dependencies
module load .time/1.9-lsi4ax6 
module use /software/projects/pawsey0835/ddeeptimahanti/modules/
module load lfric/gcc/14.2
module unload .cray-mpich/9.0.1-t6yjuyi 
module load .py-pyyaml/6.0.2-mysz5xs

# switch xios2 with self-built xios3
module unload xios/2701
module load cray-hdf5-parallel/1.14.3.5
module load cray-netcdf-hdf5parallel
module use /software/projects/pawsey0835/sbhardwaj/setonix/2026.04/modules/zen3/gcc/14.2.0
module load xios/3.0.2.2

# env variables 
export FC=ftn
export LFRIC_CORE=$(pwd)/lfric_core
export LFRIC_APPS=$(pwd)/lfric_apps
export USE_LEGACY_TIMER=1  # use timers 
export USE_TIMING_WRAPPER=1
export APP=lfric_atm

# build 
cd ${LFRIC_APPS}/build
rm -rf ${LFRIC_APPS}/applications/${APP}/working 
VERBOSE=1 python local_build.py ${APP} -c $LFRIC_CORE -j 64 2>&1 | tee output.out

echo "Job ended " $(date +"%T") # start time
