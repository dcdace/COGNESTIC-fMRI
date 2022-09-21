#!/bin/bash
# ======================================================================
# Dace Apšvalka (MRC CBU 2022)
# ======================================================================
set -eu

# Project path needs to be specified when submitting the function
PROJECT_PATH=${1}

# Where the dicoms are located
DICOM_PATH=/imaging/correia/dace/training/summer-school/Example_v02/FaceRecognition/data/dicom/
# Where to output jobs
JOB_DIR="$PROJECT_PATH"/data/work/bids/jobs
mkdir -p "$JOB_DIR"
cd "$JOB_DIR"
# Get the list of subject for this project
# each subfolder in the dicom path
SUBJECT_LIST=()
for d in "$DICOM_PATH"*; do
    sub_id=$(basename "$d")
    SUBJECT_LIST+=("$sub_id")
done
# Submit to the dicom2bids script as a job array on SLURM
sbatch --array=0-$((${#SUBJECT_LIST[@]} - 1)) "$PROJECT_PATH"/code/preprocessing/step02_heudiconv_run.sh "${PROJECT_PATH}" "${DICOM_PATH}" "${SUBJECT_LIST[@]}"