#!/bin/bash
# ======================================================================
# Dace Apšvalka (MRC CBU 2022)
# ======================================================================
# set -eu

# project path
PROJECT_PATH=${1}
# where to output jobs
JOB_DIR="$PROJECT_PATH"/data/work/mriqc/jobs
mkdir -p "$JOB_DIR"
cd "$JOB_DIR" || exit

# get the subject list 
SUBJECT_DIRS=("$PROJECT_PATH"/data/bids/sub-*)
SUBJECT_LIST=("${SUBJECT_DIRS[@]##*/}") 

# submit to SLURM
sbatch --array=0-$((${#SUBJECT_LIST[@]} - 1)) "$PROJECT_PATH"/code/preprocessing/step05_mriqc_run.sh "${PROJECT_PATH}" "${SUBJECT_LIST[@]}"
