#!/bin/bash

#SBATCH -A csc143
#SBATCH -J read
#SBATCH -t 01:25:00
#SBATCH -N 1
#SBATCH -o read.out.%j
#SBATCH -e read.err.%j

#SBATCH --ntasks-per-node=8
# Due to Frontier's Low-Noise Mode Layout only 7 instead of 8 cores are available per process
# https://docs.olcf.ornl.gov/systems/frontier_user_guide.html#low-noise-mode-layout
#SBATCH --cpus-per-task=1

date

export EXE=/lustre/orion/csc143/scratch/junmin/2024-may/build/warpx-master/bin/warpx.3d

logDir=compute_node_log_prof_a
mkdir ${logDir}
mkdir ${logDir}/bp5_f
mkdir ${logDir}/bp5_v
mkdir ${logDir}/h5_f

BP5_FILE_BASED=/lustre/orion/csc143/scratch/junmin/2024-may/Test/issue380/diags/diagBP_f/
BP5_VAR_BASED=/lustre/orion/csc143/scratch/junmin/2024-may/Test/issue380/diags/diagBP_v/
H5_FILE_BASED=/lustre/orion/csc143/scratch/junmin/2024-may/Test/issue380/diags/diagH5_f/

EXE=./run_issue380

profileLoc=/tmp/${BP5_FILE_BASED}
mkdir -p ${profileLoc}
ls -lR ${profileLoc}


mkdir -p ${profileLoc}
${EXE}  ${BP5_FILE_BASED}/openpmd_ bp f lazy >> ${logDir}/bp5_f/cc_out_380_lazy
mkdir ${logDir}/bp5_f/profile_lazy
mv ${profileLoc} ${logDir}/bp5_f/profile_lazy

profileLoc=/tmp/${BP5_VAR_BASED}
mkdir -p ${profileLoc}
ls -lR ${profileLoc}
${EXE}  ${BP5_VAR_BASED}/openpmd  bp v >> ${logDir}/bp5_v/cc_out_380
mkdir ${logDir}/bp5_v/profile
mv ${profileLoc} ${logDir}/bp5_v/profile


date
