%% 4.11 Estimating individual alpha band frequencies
% Input data: raw resting state EEG [*.eeg + *.vhdr] with eyes open and eyes
% closed conditions
%
% Fieldtrip v20170119 
% From 'Weak electric fields induce neural entrainment in humans'
% by E. Zmeykina

%% 
clear all, close all,  clc
files_hdr = dir('*p18*.vhdr'); %CHANGE PID
files_eeg = dir('*p18*.eeg'); %CHANGE PID
%%
for i=1:2 
    
    % Load and read dataset
    cfg  = []; 
    cfg.dataset                = files_eeg(i).name;
    cfg.trialdef.triallength   = Inf;
    cfg                        = ft_definetrial(cfg);

    % Preprocessing of continious data
    cfg.detrend                = 'yes';                         
    cfg.hpfilter               = 'yes'; 
    cfg.hpfreq                 = 0.1;
    cfg.hpfiltord              = 4;
    cfg.lpfilter               = 'yes';
    cfg.lpfreq                 = 40;
    cfg.demean                 = 'yes';   
    cfg.reref                  = 'yes';
    cfg.refchannel             = 'all';
    data_preproc               = ft_preprocessing(cfg);

    % Define trials - 2sec with 50% overlap
    cfg  = [];
    cfg.length                 = 2;
    cfg.overlap                = 0.5; 
    data                       = ft_redefinetrial(cfg, data_preproc);

    cfg  = [];
    cfg.method                 = 'summary';
    cfg.channel                = 'all';
    cfg.keepchannel            = 'no';
    cfg.layout                 = 'actiCAP_64_layout.mat';
    temp                       = ft_rejectvisual(cfg, data);
    
    % Frequency analysis
    cfg  = [];
    cfg.output                 = 'pow';
    cfg.method                 = 'mtmfft';
    cfg.taper                  = 'dpss';
    cfg.foi                    = 1:0.5:20;
    cfg.tapsmofrq              = 1;      
    
    eval (['dataset', num2str(i), '= ft_freqanalysis(cfg, temp);'])

end

ChanLabels = {'Pz' 'P3' 'P7' 'O1' 'Oz' 'O2' 'P4' 'P8' 'P1' 'P5' 'PO7' 'PO3' 'POz' 'PO4' 'PO8' 'P6' 'P2'};

cfg  = [];
cfg.xlim        = [4 20];
cfg.channel     = ChanLabels;
ft_singleplotER (cfg, dataset1, dataset2)
