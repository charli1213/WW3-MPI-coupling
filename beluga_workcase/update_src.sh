# This bash executable updates source files before launching the coupled model.
#   -> fetch ww3 inputs files from $ww3_inp_dir
#   -> fetch SW model compiled files (exec file AND parameters.f90_last_compiled) from $newcase_dir=/SWmodel/newcase
#   -> Fetch the ww3 forcings creation python scripts from $build_forcings_dir
#  * n.b. this function is like a "reset". 


# 1. Cleaning : 
rm *.ww3
rm *.nc
rm *.inp

# 2. Copying ww3_*.inp files into case
ww3_inp_dir=$HOME/celiz2/projects/def-lpnadeau/celiz2/mpi_work/ww3_inp_files
cp $ww3_inp_dir/*.inp .
echo " > Copying .inp files from ${ww3_inp_dir}"
rm exec
rm parameters.f90_last_compiled

# 3. Copying SW executable file 
newcase_dir=$HOME/projects/def-lpnadeau/celiz2/modelSW/newcase
cp $newcase_dir/exec .
cp $newcase_dir/parameters.f90_last_compiled .
echo " > Copying exec and parameter files from ${newcase_dir}"

# 4. Copying Python scripts for building forcings. 
build_forcings_dir=$HOME/projects/def-lpnadeau/celiz2/mpi_work/Python_build_functions
cp $build_forcings_dir/build_current.py ./PythonBuildFunc/.
cp $build_forcings_dir/build_grids.py ./PythonBuildFunc/.
cp $build_forcings_dir/build_wind.py ./PythonBuildFunc/.
echo " > Copying Python Building functions from ${build_forcings_dir}"

# END
