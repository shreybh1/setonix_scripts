#!/bin/bash --login
#SBATCH --job-name=lfric
#SBATCH --time=0:30:00
#SBATCH --account=n02-NGARCH
#SBATCH --account=pawsey0835
#SBATCH --exclude=nid00[2024-2055],nid00[2792-2823]
#SBATCH --exclusive
#SBATCH --partition=work
#SBATCH -m block:block:block

# Modules
module use /software/projects/pawsey0835/ddeeptimahanti/modules
module load lfric/cce/18.0.1
module load .py-psyclone/3.1.0-vlt43v4  # py-psyclone/3.2 does not work 
module use /software/projects/pawsey0835/ddeeptimahanti/setonix/2025.04/modules/zen3/gcc/13.3.0/dependencies
module use /software/projects/pawsey0835/ddeeptimahanti/setonix/2025.04/modules/zen3/gcc/13.3.0/astro-applications/
module load .pfunit/4.10.0-twwu3qk
module load .fcm/2021.05.0-65djiil
export FC=ftn

# OpenMP settings
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK   #To define the number of threads per task, in this case will be 64
export OMP_PLACES=cores     #To bind threads to cores
export OMP_PROC_BIND=close  #To bind (fix) threads (allocating them as close as possible). This option works together with the "places" indicated above, then: allocates threads in closest cores.

# MPI variables 
export MPICH_OFI_STARTUP_CONNECT=1
export MPICH_OFI_VERBOSE=1

#Ask MPI to provide useful runtime information (activate if debugging)
#export MPICH_ENV_DISPLAY=1
#export MPICH_MEMORY_REPORT=1

# LFRIC configs 
export NUM_LAYERS=60
export PPN=${SLURM_NTASKS_PER_NODE}
export CPT=${SLURM_CPUS_PER_TASK}
export OUTPUT_DIR=${SLURM_SUBMIT_DIR}/${DIRECTORY_NAME}/${SLURM_NNODES}_${PPN}_${CPT}/MESH_${MESH_SIZE}/PARTITION_${PARTITION_SIZE}/LAYER_${NUM_LAYERS}/${SLURM_ARRAY_TASK_ID}
export MESH_DIR="/scratch/pawsey0835/sbhardwaj/met-lfric_pawsey/meshes_dir"
export OUTPUT_FILE=output.txt 
# EXE=$(cd ../ && echo $(pwd))/bin/gungho_model
EXE=/scratch/pawsey0835/sbhardwaj/met-lfric_pawsey/svn_version/cce/lfric_apps/applications/gungho_model/bin/gungho_model

# create and cd into output directory
rm -rf ${OUTPUT_DIR}
mkdir -p ${OUTPUT_DIR}
cd ${OUTPUT_DIR}

#set up output directory with all required files + mesh configs
cp -r ${MESH_DIR}/C${MESH_SIZE}_${PARTITION_SIZE}/* ${OUTPUT_DIR} # mesh files with partitions
#cp ${MESH_DIR}/C${MESH_SIZE}_mesh.nc ${OUTPUT_DIR} # mesh files with partitions
cp ${SLURM_SUBMIT_DIR}/*.xml ${OUTPUT_DIR}  
cp ${SLURM_SUBMIT_DIR}/config_files/config_mesh${MESH_SIZE}_layers${NUM_LAYERS}.nml ${OUTPUT_DIR}
cp ${SLURM_SUBMIT_DIR}/pawsey.slurm ${OUTPUT_DIR}

# Run job
echo "Job started " $(date +"%T") 
echo "Output directory " ${OUTPUT_DIR}

srun -N ${SLURM_JOB_NUM_NODES} -n ${SLURM_NTASKS} -c ${OMP_NUM_THREADS} -m block:block:block  ${EXE} config_mesh${MESH_SIZE}_layers${NUM_LAYERS}.nml >> ${OUTPUT_FILE} 

#wait && rm *.err *.out *.nc 
echo "Job ended " $(date +"%T") # start time

sacct -j $SLURM_JOB_ID --format=JobID,User,NNodes,Elapsed,MaxRSS
