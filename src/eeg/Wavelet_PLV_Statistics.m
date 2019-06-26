%% 4.13 Analysis of rTMS-EEG
%
% From 'Weak electric fields induce neural entrainment in humans'
% by E. Zmeykina
%
% Fourier transformation 

%% Dependencies 
    clc; clear
    addpath ('D:\Software\fieldtrip-20180114\fieldtrip-20180114')
    load ('D:\cTMS\exp1\EEG_MAIN\SbjINFO.mat');
    load('D:\cTMS\exp1\Paper\Data\p09s3_clean.mat')

%% Time-frequency decomposition by wavelet analysis for frequencies: 1-30 Hz

% Simulate a sinusiodal wave at the stimulation frequency
    cfg = [];
    cfg.method = 'superimposed';
    cfg.output = 'mixed';
    cfg.fsample    = 1250;
    cfg.trllen     = 8.5;
    cfg.numtrl     = length(data_clean.trial);
    cfg.time       = data_clean.time;
    cfg.s1.freq     = 12;                      % Stimulation Frequency
    cfg.s1.phase    = deg2rad(270);
    cfg.s1.ampl     = 20;
    [sinw] = ft_freqsimulation(cfg);

% Append the wave as additional channel to the data    
    cfg=[];
    cfg.appenddim  = 'chan';
    data_sin = ft_appenddata (cfg,data_clean,sinw);
    data_sin.trialinfo = data_clean.trialinfo;

    cfg            = [];
    cfg.method     = 'wavelet';
    cfg.keeptrials = 'yes';
    cfg.output     = 'fourier';
    cfg.foi        = 1:0.05:30;
    cfg.toi        = -3.5:0.05:5; 
    cfg.width      = 5;
    cfg.gwidth     = 3;
    cfg.trials     = find(data_sin.trialinfo(:,1)==1);  % - Rhythmic condition
    data_r = ft_freqanalysis(cfg,data_sin);

    cfg.trials     = find(data_sin.trialinfo(:,1)==2);  % - Arrhythmic condition
    data_ar = ft_freqanalysis(cfg,data_sin);

    save ([OutputDir, 'p09s3_freq'], 'data_r', 'data_ar')

%% Phase locking value estimation

    cfg = [];
    cfg.method = 'plv';
    cfg.channelcmb = {'mix','all'};
    
    plv_r = ft_connectivityanalysis(cfg, data_r);
    plv_ar = ft_connectivityanalysis(cfg, data_ar);

% Change the name of the variable:
    plv_r.dimord   = 'chan_freq_time';
    plv_r.label = plv_r.labelcmb(1:63,2);
    plv_r.powspctrm = plv_r.plvspctrm;

    plv_ar.dimord   = 'chan_freq_time';
    plv_ar.label = plv_ar.labelcmb(1:63,2);
    plv_ar.powspctrm = plv_ar.plvspctrm;

% Normalize PLV by baseline 500 ms prior to rTMS onset
    cfg=[];
    cfg.baseline = [-3 -2.5];
    cfg.baselinetype = 'relative';
    cfg.parameter = 'powspctrm';
    plv_r_norm  = ft_freqbaseline (cfg, plv_r);
    plv_ar_norm = ft_freqbaseline (cfg, plv_ar);

%% Statistical analysis 

    parietal = {'Pz','P1','P3','P5','P7','O1','Oz','O2','P2','P4','P6','P8','PO7','PO3','POz','PO4','PO8'};

    cfg = [];
    cfg.channel          = parietal;
    cfg.latency          = [-3 1];
    cfg.avgovertime      = 'no';
    cfg.frequency        = 'all';
    cfg.avgoverfreq      = 'no';
    cfg.method           = 'montecarlo';
    cfg.statistic        = 'depsamplesT';
    cfg.correctm         = 'cluster';
    cfg.clusteralpha     = 0.05;
    cfg.clusterstatistic = 'maxsize';
    cfg.minnbchan        = 2;
    cfg.neighbours       = neighbours;  
    cfg.tail             = 0;
    cfg.clustertail      = 0;
    cfg.alpha            = 0.025;
    cfg.numrandomization = 1000;

    subj = 16;
    design = zeros(2,2*subj);
    for i = 1:subj
      design(1,i) = i;
    end
    for i = 1:subj
      design(1,subj+i) = i;
    end

    design(2,1:subj)        = 1;
    design(2,subj+1:2*subj) = 2;

    cfg.design   = design;
    cfg.uvar     = 1;
    cfg.ivar     = 2;

    stat = ft_freqstatistics(cfg, GROUP_LOW_R{:}, GROUP_LOW_AR{:});
    