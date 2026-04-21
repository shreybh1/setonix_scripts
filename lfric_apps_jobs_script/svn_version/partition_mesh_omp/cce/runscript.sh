# runscript to run gungho model with different layers and nodes. 
export NUM_NODES=432
export MESH_SIZE=1536
export TIME="0:20:00"
export DIRECTORY_NAME="OUTPUT_PAWSEY/svn_version/lfric_apps-11231/lfric_core-53041/cce/18.0.1"

for PARTITION_SIZE in 6912 13824 27648 55296 
do 
  PPN=$(( ${PARTITION_SIZE} / ${NUM_NODES} ))
  CPT=$(( 128 / ${PPN})) 
  for JOBS in 1 2  
  do
    echo "Num nodes="$NUM_NODES " PPN="$PPN " CPT=" $CPT " time="$TIME  " ARRAY="$JOBS " PARTITION SIZE=" ${PARTITION_SIZE} " MESH SIZE="${MESH_SIZE}
    sbatch --export=all,MESH_SIZE=${MESH_SIZE},PARTITION_SIZE=${PARTITION_SIZE},DIRECTORY_NAME=${DIRECTORY_NAME} --nodes=${NUM_NODES} --ntasks-per-node=${PPN} --cpus-per-task=${CPT} --time=${TIME} --array=${JOBS} pawsey_openmp.slurm
  done
done 
