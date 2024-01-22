#!/bin/bash
#SBATCH --job-name=COU-NC-creation
#SBATCH --account=def-lpnadeau
#SBATCH --mail-type=NONE
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=0
#SBATCH --time=01-00:00:00
#SBATCH --output=log-netCDF-creation.log

# Batch system info
echo "Current working directory: `pwd`"
echo "Starting run at: `date`"
echo "Host:            "`hostname`
echo ""

# Modules 
module load python
source $HOME/projects/def-lpnadeau/celiz2/mpi_work/Python_build_functions/ENV/bin/activate

# Task "-u" means to get output in file
python -u transfert_to_netcdf.py
python -u eke_netcdf.py
python -u power_input.py

# End
echo ""
echo "Run ended at: "`date`
