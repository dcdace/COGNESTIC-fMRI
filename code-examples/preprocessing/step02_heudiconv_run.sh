#!/bin/bash
# ======================================================================
# Dace Apšvalka (MRC CBU 2022)
# ======================================================================
set -eu

# Project path needs to be specified when submitting the function
PROJECT_PATH=${1}
# Where the dicoms are located
DICOM_PATH=${2}
# where to output the data
OUTDIR="$PROJECT_PATH"/data/bids
# All list items of the 3rd variable from batch-dicom2bids
SUBJECT_LIST=("${@:3}")
# Index each subject per job array
subject=${SUBJECT_LIST[${SLURM_ARRAY_TASK_ID}]}

# Processing start time
start=$(date +%s)
# Write out the starting details
date
echo Submitted subject: "${subject}"
echo DICOM path: "$DICOM_PATH""${subject}"/

# Do the conversion using heudiconv
heudiconv \
    -d /imaging/correia/dace/training/summer-school/Example_v02/FaceRecognition/data/dicom/{subject}/*/*/*.dcm \
    -o "${OUTDIR}" \
    -f "${PROJECT_PATH}"/code/preprocessing/heudiconv_heurisctic.py \
    -s "${subject}" \
    -c dcm2niix \
    -b --overwrite

# Procesing end time
end=$(date +%s)
# Write out the elapssed processing time
echo Time elapsed: "$(TZ=UTC0 printf '%(%H:%M:%S)T\n' $((end - start)))"
