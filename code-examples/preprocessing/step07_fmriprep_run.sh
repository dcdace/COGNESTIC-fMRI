#!/bin/sh

# processing start time
start=$(date +%s)
date
echo Submitted subject: "${2}"

# processing
singularity run --cleanenv -B "${1}":/myfMRI \
    /imaging/local/software/singularity_images/fmriprep/fmriprep-21.0.1.simg \
    /myfMRI/data/bids /myfMRI/data/bids/derivatives/fmriprep \
    --work-dir /myfMRI/data/work/fmriprep \
    participant \
    --participant-label "${2}" \
    --skip-bids-validation \
    --fs-license-file /myfMRI/license.txt \
    --output-spaces MNI152NLin2009cAsym:res-2 T1w \
    --write-graph \
    --nthreads 16 --omp-nthreads 8 \
    --stop-on-first-crash

# procesing end time
end=$(date +%s)
echo Time elapsed: "$(TZ=UTC0 printf '%(%H:%M:%S)T\n' $((end - start)))"

