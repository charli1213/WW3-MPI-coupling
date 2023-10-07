#!/bin/sh
#
#
#
build_func_path=/home/charlesedouard/Desktop/Travail/MPI_work/Python_build_functions
python $build_func_path/build_grids.py
python $build_func_path/build_current.py
python $build_func_path/build_wind.py
#
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
