# SVN version 
## Compilation 
Run the compile slurm script. Select from cce or gcc compilers.

## Add 1st timestep for partitioned mesh
- For the partitioned version running the C1536 meshes, make sure to replace the included gungho_model.f90 source code to get the first timestep value in the timer.txt files.
- `cp gungho_model.f90 $LFRIC_APPS/applications/gungho_model/source/gungho_model.f90`

