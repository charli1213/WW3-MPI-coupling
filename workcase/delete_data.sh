#!/bin/bash
#SBATCH --job-name=Deleting-Stuff
#SBATCH --account=def-lpnadeau
#SBATCH --mail-type=NONE
#SBATCH --mem=10G
#SBATCH --time=01:00:00
#SBATCH --output=None

# Batch system info
echo "Current working directory: `pwd`"
echo "Starting run at: `date`"
echo "Host:            "`hostname`
echo ""


# Task
rm data/*

# End
echo ""
echo "Run ended at: "`date`
