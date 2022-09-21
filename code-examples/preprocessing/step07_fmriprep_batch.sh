#!/bin/bash
# ======================================================================
# Dace Apšvalka (MRC CBU 2022)
# ======================================================================
# set -eu

PROJECT_PATH=${1}
# where to output jobs
JOB_DIR="$PROJECT_PATH"/data/work/fmriprep/jobs
mkdir -p "$JOB_DIR"
cd "$JOB_DIR" || exit

for d in "$PROJECT_PATH"/data/bids/sub-*/; do
    sid=$(basename "$d")    
    sbatch --time=7-00:00 --cpus-per-task=16 "$PROJECT_PATH"/code/preprocessing/step07_fmriprep_run.sh "${PROJECT_PATH}" "${sid}"
    sleep 1m   # Fmriprep: Workaround for running subjects in parallel https://neurostars.org/t/updated-fmriprep-workaround-for-running-subjects-in-parallel/6677
done