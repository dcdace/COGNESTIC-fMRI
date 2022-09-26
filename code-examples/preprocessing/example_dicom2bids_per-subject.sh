#!/bin/bash
d_path="/imaging/correia/da05/workshops/2022-09-COGNESTIC/Example_v03/FaceRecognition/data/dicom/"
o_path="/imaging/correia/da05/workshops/2022-09-COGNESTIC/Example_v03/FaceRecognition/"
sid="01"
# -d, --dicom_dir_template
# -o, --outdir
# -f, --heuristic
# -s, --subjects
# -c, --converter
# -b, --bids
heudiconv \
    -d $d_path/{subject}/*/*/*.dcm \
    -o $o_path/data/bids/ \
    -f $o_path/code/preprocessing/heudiconv_heurisctic.py \
    -s $sid \
    -c dcm2niix \
    -b --overwrite