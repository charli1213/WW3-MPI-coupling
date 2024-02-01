
# ftn 
cd $HOME/projects/def-lpnadeau/celiz2/wavewatch3/ftn
rm  w3updtmd.ftn w3wavemd.ftn ww3_shel.ftn
ln -s $HOME/projects/def-lpnadeau/celiz2/mpi_work/ww3_files/ftn/* .
cd $HOME/projects/def-lpnadeau/celiz2

# bin
cd $HOME/projects/def-lpnadeau/celiz2/wavewatch3/bin
rm make_oxygen.sh
rm switch_lizotte
rm make_beluga.sh
ln -s /home/celiz2/projects/def-lpnadeau/celiz2/mpi_work/ww3_files/bin/* .
cd $HOME/projects/def-lpnadeau/celiz2

# update_src (beluga_workcase AND oxygen_workcase)
# *** must be done by hand for now ***

