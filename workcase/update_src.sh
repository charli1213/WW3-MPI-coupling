rm *.ww3
rm *.nc
mpiworkdir=$HOME/projects/def-lpnadeau/celiz2/mpi_work/work
cp $mpiworkdir/*.inp .
echo " > Copying .inp files from ${mpiworkdir}"
rm exec
rm parameters.f90_last_compiled
casedir=$HOME/projects/def-lpnadeau/celiz2/modelSW/newcase
cp $casedir/exec .
cp $casedir/parameters.f90_last_compiled .
echo " > Copying exec and parameter files from ${casedir}"
pythondir=$HOME/projects/def-lpnadeau/celiz2/mpi_work/Python_build_functions
cp $pythondir/build_current.py ./PythonBuildFunc/.
cp $pythondir/build_grids.py ./PythonBuildFunc/.
cp $pythondir/build_wind.py ./PythonBuildFunc/.
echo " > Copying Python Building functions from ${pythondir}"
