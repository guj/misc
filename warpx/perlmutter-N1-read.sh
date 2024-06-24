#!/bin/bash -l

#SBATCH -t 00:20:00
#SBATCH -N 1
#SBATCH -J N1
#SBATCH -A m1248
#SBATCH -C cpu
#SBATCH -q regular
# SBATCH -c 32
# #SBATCH --ntasks-per-node=16
#SBATCH -o out.%j
#SBATCH -e err.%j

logDir=compute_node_log_with_profile
mkdir ${logDir}
mkdir ${logDir}/bp5_f
mkdir ${logDir}/bp5_v
#mkdir ${logDir}/h5_f

BP5_FILE_BASED=/pscratch/sd/j/junmin/perlmutter/Jan2024/Test/issue380/bp5-f/defaultBP5-rank-ews_diags_f/diag1/
BP5_VAR_BASED=/pscratch/sd/j/junmin/perlmutter/Jan2024/Test/issue380/bp5-v/diags/diag1/
#H5_FILE_BASED=/pscratch/sd/j/junmin/perlmutter/Jan2024/Test/issue380/h5-f/h5_diags_f/diag1/

EXE=./run_issue380

profileLoc=/tmp/${BP5_FILE_BASED}
mkdir -p ${profileLoc}
ls -lR ${profileLoc}

#####################
##### not lazy ######
#####################
#${EXE}  ${BP5_FILE_BASED}/openpmd_ bp f >> ${logDir}/bp5_f/cc_out_380
#mkdir ${logDir}/bp5_f/profile
#mv ${profileLoc} ${logDir}/bp5_f/profile


#####################
#####  lazy    ######
#####################
${EXE}  ${BP5_FILE_BASED}/openpmd_ bp f lazy >> ${logDir}/bp5_f/cc_out_380_lazy
mkdir ${logDir}/bp5_f/profile_lazy
mv ${profileLoc} ${logDir}/bp5_f/profile_lazy

#profileLoc=/tmp/${BP5_VAR_BASED}
#mkdir -p ${profileLoc}
#ls -lR ${profileLoc}
#${EXE}  ${BP5_VAR_BASED}/openpmd  bp v >> ${logDir}/bp5_v/cc_out_380
#mkdir ${logDir}/bp5_v/profile
#mv ${profileLoc} ${logDir}/bp5_v/profile




