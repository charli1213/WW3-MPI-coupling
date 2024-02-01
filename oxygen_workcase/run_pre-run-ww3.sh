#!/bin/sh
#
# This bash executable pre-run the model -- which means it creates and
# assimilates grids and forcings before running the shel (ww3_shel.inp).
#
build_func_path=PythonBuildFunc
echo " > Creating forcing with Python scripts from ${build_func_path}."
cd $build_func_path
python build_grids.py
python build_current.py
python build_wind.py
cd ..
#
echo " > Assimilating mapsta.inp and bottoms.inp."
ww3_grid
ww3_strt
#
echo " > Assimilating current forcings (WW3Currentforcings.nc)."
rm ww3_prnc.inp
cp prnc_cur.inp ww3_prnc.inp
ww3_prnc
#
echo " > Assimilating wind forcings (WW3Windforcings.nc)."
rm ww3_prnc.inp
cp prnc_wnd.inp ww3_prnc.inp
ww3_prnc
#
echo " > Pre-run completed."
