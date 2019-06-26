%% 4.13 Analysis of rTMS-EEG
%
% From 'Weak electric fields induce neural entrainment in humans'
% by E. Zmeykina

%% Dependencies 
    clc; clear

    addpath ('D:\Software\fieldtrip-20180114\fieldtrip-20180114')
    addpath ('D:\cTMS\exp1\Paper\dep')
    load ('D:\cTMS\exp1\EEG_MAIN\SbjINFO.mat');
    load('D:\cTMS\exp1\Paper\Data\p09s3_raw.mat')
%% Inspect for bad trials and channels

    load('actiCAP_64_neighbours.mat')
    [data_prep, arttrial, artchan, ChanWithLargeSTD] = artefacts_automatic (data_raw, neighbours);

 %% ICA2 - define EYE related components
 % Reduce the number of components as: all channels minus bad/interpolated
 % channels&trials

%     cfg=[];
%     cfg.method                       = 'summary';
%     cfg.channel                      = 'all';
%     cfg.keepchannel                  = 'no';
%     cfg.neighbours                   = neighbours;
%     cfg.layout                       = 'actiCAP_64_layout.mat';
%     data_prep                        = ft_rejectvisual(cfg, data_prep);
 
    gtrials = find (data_prep.trialinfo(:,2)==0);

    EEG.data        =   cat(3,data_prep.trial{1,gtrials});
    CovM = EEG.data(:, :)*EEG.data(:, :)'/size(EEG.data(:, :), 2);
    [~, D] = eig(CovM);
    d = sort(diag(D), 'descend');
    dd = zeros(1, length(d));
    for l = 1:length(d)
        dd(l) = sum(d(1:l));
    end
    cntNumCompForICA = sum(dd/dd(end) < .999);
    
    clearvars EEG d dd l D CovM
    
    badch = sum([artchan~=0 ChanWithLargeSTD~=0]);

% Run ICA
    cfg = [];
    cfg.demean = 'yes'; 
    cfg.method = 'runica'; 
    cfg.numcomponent = cntNumCompForICA-badch;
    cfg.trials       = gtrials;
    comp2 = ft_componentanalysis(cfg, data_prep);
    
%     cfg=[];
%     cfg.viewmode = 'component';
%     cfg.layout                      = lay;  
%     ft_icabrowser(cfg,comp2)

    idx = [1 3];
    
    cfg = [];
    cfg.component                    = idx; 
    cfg.demean                       = 'no'; 
    data_clean                       = ft_rejectcomponent(cfg, comp2, data_prep);
       
    save ([OutputDir, 'p09s3_clean'], 'data_clean')
    save ([OutputDir, 'comp'], 'comp')