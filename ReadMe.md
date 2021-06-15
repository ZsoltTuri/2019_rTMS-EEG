# Weak rTMS-induced electric fields produce neural entrainment in humans

This repository contains data and analysis scripts for our manuscript entitled "Weak rTMS-induced electric fields produce neural entrainment in humans".

If you want to use data or analysis scripts in a research publication,
please cite [our paper](https://pubmed.ncbi.nlm.nih.gov/32686711/).

## 1. Citation
Zmeykina E, Mittner M, Paulus W, Turi Z. Weak rTMS-induced electric fields produce neural entrainment in humans. Sci Rep. 2020 Jul 20;10(1):11994. doi: 10.1038/s41598-020-68687-8. PMID: 32686711; PMCID: PMC7371859.

~~~
@article{zmeykina2020weak,
  title={Weak rTMS-induced electric fields produce neural entrainment in humans},
  author={Zmeykina, Elina and Mittner, Matthias and Paulus, Walter and Turi, Zsolt},
  journal={Scientific Reports},
  volume={10},
  number={1},
  pages={1--16},
  year={2020},
  publisher={Nature Publishing Group}
}
~~~

## 2. License
The content of the repository is licensed under a Creative Commons Attribution-NonCommercial 4.0 International
License (CC BY-NC 4.0), which permits non-commercial use, sharing, adaptation, distribution and reproduction in any medium or format, as long as you give appropriate credit to the original author(s) and the source, provide a link to the Creative Commons license, and indicate if changes were made. 

## 3. Linked Open Science Framework (OSF) repository
This github repository is linked to our [2019_rTMS-EEG](https://osf.io/3xuk8/) OSF repository. MRI and EEG files are stored in OSF.

## 4. Raw data
Pseudonym raw data is located in `data/` folder. 
We share the following types of raw data in the subfolders: 

### 4.1. Raw data: MRI 
Path: `data/mri` in the OSF storage

For each participant, we share anatomical and diffusion magnetic resonance imaging (MRI) data.
MRI data is organized according to the [Brain Imaging Data Structure (BIDS)](https://bids.neuroimaging.io/).
Niftii images corresponding to the anatomical MRI are defaced by using the python-based defacing utility for MRI images called [pydeface](https://github.com/poldracklab/pydeface). 

### 4.2. Raw data: EEG 
Path: `data/eeg` in the OSF storage

We attained scalp-recorded EEG data by using 24-bit, battery-supplied, active channel amplifier with 64 Ag/AgCl active EEG electrodes (actiCAP, BrainVision LLC, Germany) at 2.5 kHz sampling rate and w/o hardware filters (actiChamp, Brain Vision LLC, Germany). Ground and reference electrodes were located at Fpz and FCz, respectively. 

EEG data is currently shared in raw format. However, we may provide data and script in BIDS format in the future. 

### 4.3. Raw data: EF
Path: `data/ef`

Electric-field (EF) simulation were performed by [SimNIBS](https://simnibs.github.io/simnibs/build/html/index.html), which is a free and open source software package for the Simulation of Non-invasive Brain Stimulation. 
In the experiment, we used non-defaced MRI data for EF simulations. We cannot share these non-defaced head models, due to ethical reasons. 
However, we share descriptive statistics derived from head models. 
The `.R` scripts located in `data` load the corresponding raw files into `R`
workspace under the name of the `R`-file (without the `.R` extension).

#### 4.3.1. The EF folder content
- `data/ef/distance`: contains the amount by which EEG channel positions were offset, due to skin-gray matter
distance. 

- `data/ef/EEG_roi`: contains EF values extracted from the gray matter compartment underneath of left posterior electrodes by using 10 mm sherical ROIs

- `data/ef/peak_EF`: contains peak EF values corresponding to 3 rTMS and 5 RMT data 
- `data/ef/plv`: contains phase locking values

- `data/ef/roi_EF`: contains EF values in each ROI

## 5. Analyses
### 5.1. Analysis: EEG
All analyes about rTMS-EEG is located in `src/eeg`.
To run the scripts, you need to have Matlab and [FieldTrip](http://www.fieldtriptoolbox.org/), the latter of which is the MATLAB software toolbox for MEG, EEG, iEEG and NIRS analysis. 

### 5.2. Analysis: EF
All analyses about the EF stimulations are located in `src/ef`. 
To run the scripts, you need to have the `ProjecTemplate` package and various other packages
installed. `config/global.dcf` specifies the required packages.

The first two lines in each file
~~~{R}
library(ProjectTemplate)
load.project()
~~~
convert the raw data into a more convenient format by

1. running the `data/<dataset>.R` file
2. running the preprocessing scripts in `munge`
3. loading the convenience functions in `lib`
