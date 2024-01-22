#!/bin/bash
#SBATCH --job-name=pre-run-WW3
#SBATCH --account=def-lpnadeau
#SBATCH --mail-type=NONE
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=0
#SBATCH --time=00-03:30:00
#SBATCH --output=log-pre-run.log



# Batch system info
echo "Current working directory: `pwd`"
echo "Starting run at: `date`"
echo "Host:            "`hostname`
echo ""


build_func_path=PythonBuildFunc
cd $build_func_path
python build_grids.py
python build_current.py
python build_wind.py
#
cd ..
ww3_grid
ww3_strt
#
rm ww3_prnc.inp
cp prnc_cur.inp ww3_prnc.inp
ww3_prnc
#
rm ww3_prnc.inp
cp prnc_wnd.inp ww3_prnc.inp
ww3_prnc
#
echo "Pre-run done"




# End
echo ""
echo "Run ended at: "`date`
