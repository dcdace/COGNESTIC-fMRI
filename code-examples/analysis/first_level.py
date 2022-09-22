#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ======================================================================
# Dace Apšvalka (MRC CBU 2022)
# First level fMRI analysis using Nilearn
# ======================================================================

# ======================================================================
# IMPORT RELEVANT PACKAGES
# ======================================================================
import os
import sys
import pandas as pd
import numpy as np
from bids.layout import BIDSLayout
from nilearn.glm.first_level import FirstLevelModel

# ======================================================================
# DEFINE PATHS
# ======================================================================
ds = '/imaging/correia/dace/training/summer-school/Example_v03/FaceRecognition' #sys.argv[1] # dataset location
sID = '14' #sys.argv[2].split("sub-")[1]  
bids_path = os.path.join(ds, 'data/bids')
outdir = os.path.join(ds, 'results/first-level-2mm', 'sub-' + sID)
if not os.path.exists(outdir):
    os.makedirs(outdir)

# ======================================================================
# PERFORM SUBJECT LEVEL GLM ANALYSIS
# ======================================================================

# Initialize the BIDS layout and include the derivatives in it
layout = BIDSLayout(bids_path, derivatives=True)

# Get the TR value
TR = layout.get_tr()

# Define the GLM model
fmri_glm = FirstLevelModel(t_r = TR,
                           noise_model = 'ar1',
                           hrf_model = 'spm',
                           drift_model = 'Cosine',
                           high_pass = 1./128,
                           slice_time_ref = 0.5, 
                           smoothing_fwhm = 4,
                           signal_scaling = False,
                           minimize_memory = False)

# Get the preprocessed functional files
bold = layout.get(subject=sID, datatype='func', space='MNI152NLin2009cAsym', desc='preproc', extension='.nii.gz', \
                 return_type='filename')
"""
# -------
# To resample at BOLD image level, uncomment this block
from nilearn.datasets import load_mni152_template
template = load_mni152_template()

from nilearn.image import resample_to_img
resampled_images = []
for img in bold:
    resampled_images.append(resample_to_img(img, template))
bold = resampled_images
# -------
"""
# Get the event files
events = layout.get(subject=sID, datatype='func', suffix='events', extension=".tsv", return_type='filename')
# Get the confounds and select which ones to include in the design
confounds = layout.get(subject=sID, datatype='func', desc='confounds', extension=".tsv", return_type='filename')
confounds_of_interest = ['trans_x', 'trans_y', 'trans_z', 'rot_x', 'rot_y', 'rot_z']
confounds_glm = []
for conf_file in confounds:
    this_conf = pd.read_table(conf_file)
    conf_subset = this_conf[confounds_of_interest].fillna(0) # replace NaN with 0
    confounds_glm.append(conf_subset)

# Fit the model
fmri_glm = fmri_glm.fit(bold, events, confounds_glm)

# Create contrasts
design_matrices = fmri_glm.design_matrices_

contrast_list = []
for design_matrix in design_matrices:
    """A small routine to append zeros in contrast vectors"""
    n_columns = design_matrix.shape[1] #number of predictors in our model
    def pad_vector(contrast_, n_columns):    
        return np.hstack((contrast_, np.zeros(n_columns - len(contrast_))))
    contrasts = {'FamousUnfamiliar': pad_vector([1, 0, 0, -1], n_columns),
                'UnfamiliarFamous': pad_vector([-1, 0, 0, 1], n_columns),
                'FacesScrambled': pad_vector([1, 0, -2, 1], n_columns),
                'ScrambledFaces': pad_vector([-1, 0, 2, -1], n_columns),
                'EffectsOfInterest': np.eye(n_columns)[:4]}
    contrast_list.append(contrasts)

# Compute the contrasts
stats_type = ['effect_size', 'stat']
for stats in stats_type:
    for contrast_id in contrast_list[0].keys():    
        stats_map = fmri_glm.compute_contrast(
            [c[contrast_id] for c in contrast_list], 
            output_type = stats)
        # Save results following BIDS standart
        res_name = os.path.basename(bold[0]).split("run")[0]
        stats_map.to_filename(os.path.join(outdir, res_name + 'desc-' + contrast_id + '_' + stats + '.nii.gz'))