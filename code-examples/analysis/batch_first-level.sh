#!/bin/bash
# ======================================================================
# Dace Apšvalka (MRC CBU 2022)
# ======================================================================
# set -eu

# project path
PROJECT_PATH=${1}

# get the subject list 
SUBJECT_DIRS=("$PROJECT_PATH"/data/bids/sub-*)
SUBJECT_LIST=("${SUBJECT_DIRS[@]##*/}") 

# process in parallel
for sub in "${SUBJECT_LIST[@]}"
do
     srun "$PROJECT_PATH"/code/analysis/first_level.py "${PROJECT_PATH}" ${sub} &
done

wait