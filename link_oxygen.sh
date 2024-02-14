
masterdir=$HOME/Desktop/workdir

# ftn
cd $masterdir/wavewatch/ftn
rm  w3updtmd.ftn w3wavemd.ftn ww3_shel.ftn
ln -s $masterdir/mpi_work/ww3_files/ftn/* .
cd $masterdir

# bin
cd $masterdir/wavewatch/bin
rm make_oxygen.sh
rm comp.Oxygen_gfortran
rm link.Oxygen_gfortran
rm switch_lizotte
rm make_beluga.sh
ln -s $masterdir/mpi_work/ww3_files/bin/* .
cd $masterdir

# update_src (beluga_workcase AND oxygen_workcase)
# *** must be done by hand for now ***

