#!/bin/bash
#
# Run process in the background.
#
# Tasks ( 12 cores on Oxygen, according to Ambrish ;)  

(
    echo " > Launching both models in MPI (SSTEP%). [`date`]"
    nohup { mpirun -np 9 ww3_shel : -np 1 ./exec ;} | cat > log-coupled_model.log &
    echo " > Run completed [`date`]"
)
