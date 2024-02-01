#!/bin/bash
# ---------------------------------------------------------------------------- #
# This bash script precompile AND compile the Wavewatch                        #
# III model in MPI mode for Beluga.                                            #
#                                                                              #
#                                                C.-É. Lizotte                 #
#                                                 febuary 2023                 #
#                                                                              #
# ---------------------------------------------------------------------------- #
#
# 1. Set-up - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo " > Setting-up directories."
wwatch_dir=$HOME/projects/def-lpnadeau/celiz2/wavewatch3/
switch_file=lizotte
#
# 2. Modules Intel  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo " > Loading Intel modules"
module load intel
#
# 3. cleaning - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
echo " > Cleaning model "
w3_new all
w3_clean
#
# 4. Précompilation et compilation sans MPI (avec Intel)  - - - - - - - - - - -
# n.b we do that because netCDF module only works with Ifort on compute
#     canada (sadly). 
echo " > Setting up switches and compiler for non MPI part (Intel)."
echo 'n' | w3_setup $wwatch_dir -s $switch_file -c Intel
echo " > Compiling non MPI part"
w3_make
#
# 5. Précompilation et compilation avec MPI (avec Gfortran) - - - - - - - - - -
# n.b. we do that because fishpack only works with gfortran, therefor we can
#      only use mpi with a gfortran compiled code...
echo " > Loading GCC module"
module load gcc
echo ' > Setting up compiler for MPI (Gfortran)'
echo 'n' | w3_setup $wwatch_dir -s $switch_file -c gfortran
echo " > Finally compiling MPI part"
make_MPI
#
# 6. Fin  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
module load gcc
echo " >>> End"
