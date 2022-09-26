#!/bin/bash
# ======================================================================
# Dace Apšvalka (MRC CBU 2022)
# ======================================================================
set -eu

sourcepath="/mridata/cbu/"
destpath="/imaging/correia/da05/workshops/2022-09-COGNESTIC/Example_v03/FaceRecognition/data/dicom/"


CBUid=("CBU090942" "CBU090938" "CBU090964" "CBU090928" "CBU090931" "CBU090935" "CBU090970" "CBU090956" "CBU090958" "CBU090968" "CBU090957" "CBU090966" "CBU090951" "CBU090945" "CBU090962" "CBU090967")
projectCode="MR09029"
nr=0

for id in "${CBUid[@]}"; do
    nr=$((nr + 1))
    # change sub id to be 01 02 ...
    newid=$(printf "%02d" "$nr")

    source="$sourcepath""$id"_"$projectCode"
    destination="$destpath""$newid"

    srun -N1 -n1 -c1 cp -R "$source" "$destination" &
    echo "$source"  copied

done

