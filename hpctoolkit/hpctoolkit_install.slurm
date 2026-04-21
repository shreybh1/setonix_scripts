#!/bin/bash
#SBATCH --job-name=hpctoolkit
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --cpus-per-task=1
#SBATCH --partition=work

echo "Job started " $(date +"%T") 

module load PrgEnv-gnu
module load gcc-native/14.2
#module load gcc-native/12
module load spack/0.23.1

spack env activate hpctoolkit
#spack env activate hpctoolkit_gcc_12

spack concretize -f 
spack install --verbose  

echo "Job ended " $(date +"%T") # start time
