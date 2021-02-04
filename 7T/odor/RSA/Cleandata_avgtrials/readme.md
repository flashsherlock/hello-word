# RSA
Representation similarity analysis. Trials for each odor are averaged.

## betaCorrespondence.m
List of condition names. For example, *'[[subjectName]]_exp1_lim1'*.

## get_name_afni.m
Generate image file names used in `fMRIDataPreparation_afni.m`.

## fMRIDataPreparation_afni.m
Load data from BRIK files (requiring functions in the decoding toolbox). Each **column** is a **conditon** corresponding to names defined in `betaCorrespondence.m`. Results will be saved to folder "imagedata".

## fMRIMaskPreparation_afni.m
Load mask from BRIK files. Results are masks (1×n_voxels matrices) in side a structure named by subjects, which will be saved to folder "imagedata".

## defineUserOptions.m
RSA options.

## read_rating.m
Read intensity and valence ratings. Return a n_odors × 2 (valence, intensity) matrix, the first column is valence, the second column is intensity.

## modelRDMs_7T.m
Hypothesis RDMs to be tested.
* absolute (0 and 1) quality
* absolute (0 and 1) structure
* Atom pairs tanimoto
* MCS tanimoto
* intensity
* valence
* perception (based on intensity and valence)
* random

## Recipe_fMRI.m
Main workflow for ROI analysis.