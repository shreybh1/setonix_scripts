# LFRIC scripts for Setonix 
Here are a collection of setonix scrtips for use with lfric. 

# Get repository from svn/git. Now its mainly git. 
## SVN version
The version used for the partitioned mesh 1536. 
The repositories used are the following:

LFRIC core: `svn co -r 53041 https://code.metoffice.gov.uk/svn/lfric/LFRic/trunk lfric_core`

LFRIC apps: `svn co -r 11231 https://code.metoffice.gov.uk/svn/lfric_apps/main/trunk lfric_apps` 

## GCC version
The GCC version is used for any developments after the SVN change-over. Version 3.1 and 3.1.1 are used for lfric_core and lfric_apps  

LFRIC core: `git clone https://github.com/MetOffice/lfric_core.git lfric_core_vn3.1 && cd lfric_core_vn3.1 && get checkout vn3.1`

LFRIC apps: `git clone https://github.com/MetOffice/lfric_apps.git lfric_apps_vn3.1.1 && cd lfric_apps_vn3.1.1 && git checkout vn3.1.1`

# LFRIC job submission scripts 
## C1536 partitioned jobs
Run `./runscript.sh` which sets the correct number of threads for the number of partitions and calls `pawsey_openmp.slurm`

## For non partitioned jobs
Run `pawsey_openmp.slurm`
