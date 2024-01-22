#!/bin/bash
#SBATCH --job-name=3nzCOUYYY_SXXX%
#SBATCH --account=def-lpnadeau
#SBATCH --mail-type=NONE
#SBATCH --nodes=1
#SBATCH --ntasks=18
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=5G
#SBATCH --time=07-00:00:00
#SBATCH --output=log-coupled_model.log

# Batch system info
echo "Current working directory: `pwd`"
echo "Starting run at: `date`"
echo "Host:            "`hostname`
echo ""


# Task
#srun -n 17 --exclusive ww3_shel &
#srun -n 1 --exclusive ./exec &
#wait
mpirun -np 17 ww3_shel : -np 1 ./exec


# End
echo ""
echo "Run ended at: "`date`
