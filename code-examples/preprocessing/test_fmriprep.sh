#!/bin/sh
singularity run --cleanenv -B /imaging/correia/da05/workshops/2022-09-COGNESTIC/Example_v03/FaceRecognition:/myfMRI \
    /imaging/local/software/singularity_images/fmriprep/fmriprep-21.0.1.simg \
    /myfMRI/data/bids /myfMRI/data/bids/derivatives/fmriprep \
    --work-dir /myfMRI/data/work/fmriprep \
    participant \
    --participant-label sub-14 \
    --skip-bids-validation \
    --fs-license-file /myfMRI/license.txt \
    --output-spaces MNI152NLin2009cAsym \
    --write-graph \
    --nthreads 16 --omp-nthreads 8 \
    --stop-on-first-crash \
    --fs-no-reconall 