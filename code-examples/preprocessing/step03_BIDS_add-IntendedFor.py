#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ======================================================================
# SCRIPT INFORMATION:
# Add IntendedFor to Fieldmap JSON files
# Adapted from LENNART WITTKUHN https://github.com/lnnrtwttkhn/highspeed-bids
# ======================================================================
# IMPORT RELEVANT PACKAGES
# ======================================================================
import os
import glob
import json
import stat
import sys
# ======================================================================
# DEFINE PATHS
# ======================================================================
# to run type python3 bids-fieldmaps.py $PATH_ROOT
path_root = sys.argv[1]
path_fmap = os.path.join(path_root, '*', 'fmap', '*.json')
path_func = os.path.join(path_root, '*', 'func', '*.nii.gz')
# ======================================================================
# UPDATE FIELDMAP JSON FILES
# ======================================================================
# get all fieldmap files in the data-set:
files_fmap = glob.glob(path_fmap)
# loop over all field-map files:
for file_path in files_fmap:
    # open the .json file of the fieldmap acquisition:
    with open(file_path, 'r') as in_file:
        json_info = json.load(in_file)
    in_file.close()
    # get the path to the session folder of a specific participant:
    file_base = os.path.dirname(os.path.dirname(file_path))
    # get the path to all functional acquisitions in that session:
    files_func = glob.glob(os.path.join(file_base, 'func', '*bold.nii.gz'))
    #session = os.path.basename(file_base)
    #up_dirs = os.path.join(session, 'func')
    up_dirs = 'func'
    intended_for = [os.path.join(up_dirs, os.path.basename(file)) for file in files_func]
    json_info["IntendedFor"] = sorted(intended_for)
    # change file permissions to read:
    permissions = os.stat(file_path).st_mode
    os.chmod(path=file_path, mode=permissions | stat.S_IWUSR)
    # save updated fieldmap json-file:
    with open(file_path, 'w') as out_file:
        json.dump(json_info, out_file, indent=2, sort_keys=True)
    out_file.close()
    # change file permissions back to read-only:
    os.chmod(path=file_path, mode=permissions)
