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
#
# 1. Set-up - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo " > Setting-up wwatch directories and variables."
wwatch_dir=/aos/home/celizotte/Desktop/workdir/wavewatch/
switch_file=lizotte
# export variables and paths (you can also add this part to your " .bashrc ".
export WWATCH3_NETCDF=NC4
export NETCDF_CONFIG=/usr/bin/nc-config
PATH=$PATH:$wwatch_dir/bin
PATH=$PATH:$wwatch_dir/exe
export PATH
# Loading MPI 
#module load mpi/latest
module load mpi/2021.6.0
#
# 3. cleaning - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
echo " > Cleaning model "
w3_new all
w3_clean
#
# 4. Précompilation et compilation sans MPI (avec Intel)  - - - - - - - - - - -
# n.b we do that because netCDF module only works with Ifort on compute
#     canada (sadly). 
echo " > Setting up switches and compiler for non MPI part (gfortran)."
echo 'n' | w3_setup $wwatch_dir -s $switch_file -c Oxygen_gfortran
echo " > Compiling non MPI part"
w3_make
#
# 5. Précompilation et compilation avec MPI (avec Gfortran) - - - - - - - - - -
# n.b. we do that because fishpack only works with gfortran, therefor we can
#      only use mpi with a gfortran compiled code...
echo " > Loading GCC mpi module"
make_MPI
#
# 6. Fin  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo " >>> End"
