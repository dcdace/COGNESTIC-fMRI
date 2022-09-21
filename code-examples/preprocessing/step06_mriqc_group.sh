#!/bin/bash
set -eu

# processing start time
start=$(date +%s)
date

singularity run --cleanenv -B "${1}":/"${1}" \
    /imaging/local/software/singularity_images/mriqc/mriqc-22.0.1.simg \
    "${1}"/data/bids "${1}"/data/bids/derivatives/mriqc/ \
    --work-dir "${1}"/data/work/mriqc/ \
    group \
    --no-sub \
    --float32 \
    --n_procs 16 --mem_gb 24 \
    --ants-nthreads 16 \
    --modalities T1w bold \
    --no-sub

# procesing end time
end=$(date +%s)
echo Time elapsed: "$(TZ=UTC0 printf '%(%H:%M:%S)T\n' $((end - start)))"