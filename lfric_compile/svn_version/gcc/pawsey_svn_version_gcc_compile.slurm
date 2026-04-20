#!/bin/bash
#SBATCH --job-name=lfric_comp
#SBATCH --time=0:20:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --partition=debug

echo "Job started " $(date +"%T")

# GCC
module use /software/setonix/2025.08/modules/zen3/gcc/14.2.0/dependencies
module load .time/1.9-lsi4ax6
module use /software/projects/pawsey0835/ddeeptimahanti/modules/
module load lfric/gcc/14.2
module unload .cray-mpich/9.0.1-t6yjuyi
module load .py-pyyaml/6.0.2-mysz5xs

# env variables
export FC=ftn
export LFRIC_CORE=$(pwd)/lfric_core
export LFRIC_APPS=$(pwd)/lfric_apps
export USE_LEGACY_TIMER=1  # use timers
export USE_TIMING_WRAPPER=1
export APP=gungho_model

# build
cd ${LFRIC_APPS}/build
rm -rf ${LFRIC_APPS}/applications/${APP}/working
VERBOSE=1 python local_build.py -a ${APP} -c $LFRIC_CORE -p meto-azspice -o production -j 64 2>&1 | tee output.out

echo "Job ended " $(date +"%T") # start time
