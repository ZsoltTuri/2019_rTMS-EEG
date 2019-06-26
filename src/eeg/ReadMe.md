The folder contains scripts used for rTMS-EEG analysis as well as an example dataset from sub_09, session 3. The example datasets for all preprocessing steps can be found in 'data/eeg/example_dataset.zip' in the OSF storage.

- EstimateIAF.m - script used for online estimation of individual alpha frequency peak in range of 8-12 Hz using resting state EEG data.

- Preprocessing_blocksprepare.m - script used for preparing data from each stimulation block in one dataset. Here, the trials were defined using dep/findpeaks_rTMS.m

- Preprocessing_artefacts.m - script used for cleaning EEG data from artefacts such as: bad electrode's signal, bad trials, eye-related artefacts by semi-automatic algorithm adapted from [ARTIST] (doi:10.1002/hbm.23938)

- Wavelet_PLV_Statistics.m - time-frequency decomposition and PLV estimation. Statistical analysis was performed for comparison between rhythmic and arrhyhtmic conditions on the group-level data separately for each intensity condition.
