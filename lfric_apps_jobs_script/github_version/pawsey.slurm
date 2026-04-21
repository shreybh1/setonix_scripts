#!/bin/bash
#SBATCH --job-name=lfric
#SBATCH --time=0:10:00
#SBATCH --nodes=192
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=4
#SBATCH --exclude=nid00[2024-2055],nid00[2792-2823]
#SBATCH --exclusive
#SBATCH --partition=work

export OMP_NUM_THREADS=1

export SRUN_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK

EXE=$(cd ../ && echo $(pwd))/bin/gungho_model

module use /software/projects/pawsey0835/ddeeptimahanti/modules
module load lfric/cce/18.0.1
module use /software/projects/pawsey0835/ddeeptimahanti/setonix/2025.04/modules/zen3/gcc/13.3.0/dependencies
module use /software/projects/pawsey0835/ddeeptimahanti/setonix/2025.04/modules/zen3/gcc/13.3.0/astro-applications/
module load .pfunit/4.10.0-twwu3qk
module load .fcm/2021.05.0-65djiil
cd /software/projects/pawsey0835/sbhardwaj/met-lfric-pawsey
export FC=ftn

export MESH_SIZE=1024
export NUM_LAYERS=60
export OUTPUT_DIR=${SLURM_SUBMIT_DIR}/OUTPUT_PAWSEY/github_version/baseline/${SLURM_NNODES}_${SLURM_NTASKS_PER_NODE}_${SLURM_CPUS_PER_TASK}/MESH_${MESH_SIZE}/LAYER_${NUM_LAYERS}/${SLURM_ARRAY_TASK_ID}
export OUTPUT_FILE=output.txt 
rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}

#set up output directory with all required files + mesh configs
cp ${SLURM_SUBMIT_DIR}/*.xml ${OUTPUT_DIR}  
cp ${SLURM_SUBMIT_DIR}/mesh_files/C${MESH_SIZE}_mesh.nc ${OUTPUT_DIR}
cp ${SLURM_SUBMIT_DIR}/config_files/config_mesh${MESH_SIZE}_layers${NUM_LAYERS}.nml ${OUTPUT_DIR}
cp ${SLURM_SUBMIT_DIR}/pawsey.slurm ${OUTPUT_DIR}


export MPICH_OFI_RMA_STARTUP_CONNECT=1
cd ${OUTPUT_DIR}
#if ! [ -d ../../lfric_atm/metadata/ ]; 
#  then echo "metadata doesn't exist" 
#  mkdir -p ../../lfric_atm/metadata/
#  cp ${SLURM_SUBMIT_DIR}/../../lfric_atm/metadata/*.xml  ../../lfric_atm/metadata/
#fi 

echo "Job started " $(date +"%T") 
echo "Output directory " ${OUTPUT_DIR}

srun --distribution=block:block --hint=nomultithread ${EXE}  config_mesh${MESH_SIZE}_layers${NUM_LAYERS}.nml >> ${OUTPUT_FILE} 

wait

#rm *.err *.out *.nc 
rm *.nc 
echo "Job ended " $(date +"%T") # start time


sacct -j $SLURM_JOB_ID --format=JobID,User,NNodes,Elapsed,MaxRSS
