#!/bin/bash
#SBATCH --job-name=xios
#SBATCH --time=0:20:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --partition=debug

#module load cce/18.0.1
module load gcc-native/14.2
module load cray-hdf5-parallel/1.14.3.5
module load cray-netcdf-hdf5parallel

export SOFTWARE_DIR=$(cd ../ && echo $(pwd))
export XIOS_DIR=${SOFTWARE_DIR}/setonix/2026.04/software/gcc/14.2.0/xios/3.0.2.2
rm -rf ${XIOS_DIR}
mkdir -p ${XIOS_DIR}
export FC=ftn

cd ${SOFTWARE_DIR}/xios 
./make_xios --arch_path ${SOFTWARE_DIR}/xios_arch_files --arch cray --job 8 --prod --fcm new --build_path ${XIOS_DIR} 
