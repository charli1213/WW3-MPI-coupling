#!/bin/bash

# Batch system info
echo "Current working directory: `pwd`"
echo "Starting run at: `date`"
echo "Host:            "`hostname`
echo ""

# Task
nohup rm data/* | cat > log-deletion.log &

# End
echo ""
echo "Run ended at: "`date`
