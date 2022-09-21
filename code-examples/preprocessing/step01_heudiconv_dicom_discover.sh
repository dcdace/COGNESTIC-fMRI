#!/bin/bash
d_path="/imaging/correia/dace/training/summer-school/Example_v03/FaceRecognition/data/dicom/"
o_path="/imaging/correia/dace/training/summer-school/Example_v03/FaceRecognition/"
sid="01"
# -d, --dicom_dir_template
# -o, --outdir
# -f, --heuristic
# -s, --subjects
# -c, --converter
# -b, --bids
heudiconv \
    -d $d_path/{subject}/*/*/*.dcm \
    -o $o_path/data/work/dicom_discovery/ \
    -f convertall \
    -s $sid \
    -c none \
    -b --overwrite