#!/bin/bash

echo "Submiting several jobs"

# Submitting pre-run job -- no dependency for now
# NB. "parsable" means only jobID as output.
jobID0=$(sbatch --parsable run-prerun_ww3.slurm)
echo "ID of WW3-prerun job : ${jobID0}"

# Submitting model-run job -- dependant on model completion :
jobID1=$(sbatch --parsable --dependency=afterok:${jobID0} run-model.slurm)
echo "ID of netCDF creation job : ${jobID1}"

# Submitting netCDF creation jobs :
jobID2=$(sbatch --dependency=afterok:$jobID1 run-netCDF-creation.slurm)
echo "ID of delete data run : $jobID2"
echo "All jobs launched"
