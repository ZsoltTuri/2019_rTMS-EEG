%% 4.13 Analysis of rTMS-EEG
%
% Files description:
%-------------------
% SUBJ          --  Number of subject. Information about ID and stim parameters are in
%                   'SbjINFO.mat'
% SESSION       --  's3', 's4', 's5' TMS-EEG sessions.  
% BLOCK         --  'b01', 'b02', ... 'b10' - 10 blocks of stimulation with
%                   randomized order of stimulation CONDITIONS
% CONDITIONS    --  'R' - 1 Rhythmic rTMS with stimulation frequency = IAF
%                   'AR'- 2 ARhythmic rTMS with random stimulation frequency
% TRIAL         --  stimulation BURST, surrounded by 5 sec before + 5 sec
%                   after TMS BURST
% BURST         --  TMS pulses. Frequency is different, it depends on CONDITION (R & AR)
% GROUP         --  'LI', 'MI', 'HI' - based on stimulation intensity -> induced E-field 
%                   (20V/m - low, 35V/m - medium, 50V/m - high )
%
% From 'Weak electric fields induce neural entrainment in humans'
% by E. Zmeykina

%% Dependencies 
clc; clear

addpath ('D:\Software\fieldtrip-20180114\fieldtrip-20180114')
addpath ('D:\cTMS\exp1\Paper\dep')
load ('D:\cTMS\exp1\EEG_MAIN\SbjINFO.mat');

%% Load data and prepare filenames

SUBJ         = 9;      % from 1 to 16
SESS         = 1;      % 1-'s3', 2-'s4', 3-'s5'

InputDir     = 'D:\cTMS\exp1\EEG_MAIN\DATA_RAW\TMS-EEG'; %Raw data
OutputDir    = 'D:\cTMS\exp1\Paper\Data\';

cd (InputDir)
files_hdr       = dir(['*p09*s3*r.vhdr']);
files_eeg       = dir(['*p09*s3*r.eeg']);

%% 
for i=1:10 
    % Define trials
    cfg = [];
    cfg.dataset                      = files_hdr(i).name;
    cfg.eegdata                      = files_eeg(i).name;
    cfg.trialdef.eventtype           = 'TMSburst';
    cfg.trialdef.eventvalue          = 'S  2';
    cfg.trialdef.eventtype2          = 'TMSpulse';
    cfg.trialdef.eventvalue2         = 'S  3';
    cfg.trialdef.pulseperburst       = 20;
    cfg.trialdef.trialonset          = 'last';
    cfg.trialdef.prestim             = -3.5;
    cfg.trialdef.poststim            = 5;
    cfg.trialfun                     = 'findpeaks_rTMS';
    cfg                              = ft_definetrial(cfg);
    trlold                           = cfg.trl;
        
    % Define and cut out ringing artefacts from TMS pulse: from -4 ms to 9 ms 
    cfg.method                       = 'marker';
    cfg.dataset                      = files_hdr(i).name;
    cfg.prestim                      = -0.004;
    cfg.poststim                     = 0.009;

    cfg.trialdef.eventtype           = 'TMSpulse';
    cfg.trialdef.eventvalue          = {'S  3'};
    [cfg_ringing, artifact_ringing]  = ft_artifact_tms(cfg);

    cfg_ringing.dataset                      = files_hdr(i).name;
    cfg_ringing.artfctdef.reject             = 'partial';
    cfg_ringing.artfctdef.feedback           = 'no';
    cfg_ringing.artfctdef.ringing.artifact   = artifact_ringing;
    cfg_ringing.artfctdef.minaccepttim       = 0.0001;
    cfg_artifact                             = ft_rejectartifact(cfg_ringing);
    cfg.detrend                              = 'yes';
    dataset                                  = ft_preprocessing(cfg_artifact);

    % Define decay artefact by fastICA
    cfg = [];
    cfg.demean = 'yes'; 
    cfg.method = 'fastica';        
    cfg.fastica.approach = 'symm'; 
    cfg.fastica.g = 'gauss'; 
    comp_decay = ft_componentanalysis(cfg, dataset);

    % Detect and remove component correspond to decay (>30µV within 50 ms after TMS pulse)
    st = []; % short trials for TMS pulses = 475 in total
    for k=1:length(comp_decay.trial)
        if length(comp_decay.time{k})<1000 && length(comp_decay.time{k})>=125
            st = [st k];
        end
    end

    %Select only trials after TMS pulse
    cfg=[];
    cfg.trials = st;
    comp_d = ft_selectdata(cfg,comp_decay);

    % Align all trials to 0 time point by changing info in time (Does not change real data)
    % Only for averaging components for detection of IC component = Decay

    for cc = 1:length(comp_d.time)
        dd = length(comp_d.time{cc});
        comp_d.time{cc}(1:end)= 1:dd;
    end

    cfg = [];
    cfg.vartrllength               = 2; 
    comp_d_avg                     = ft_timelockanalysis(cfg, comp_d);

    % Find the component with magnitude > 30 µV at the 50 ms after pulses
    artcomp = [];
    W = comp_d_avg.unmixing;
    Wm = pinv(W);
    source = comp_d_avg.avg;
    for ii = 1:size(Wm, 2)
        sourcesig = squeeze(mean(abs(source(ii,1:125,:)), 2)); %125 corresponds to 50ms after the TMS pulse
        I = find(sourcesig > 30); % 30µV - max magnitude of component
        if ~isempty(I)
            artcomp = [artcomp ii];
        end
    end

    cfg = [];
    cfg.component                    = artcomp; 
    cfg.demean                       = 'no'; 
    dataset2                         = ft_rejectcomponent(cfg, comp_decay, dataset);

    %Redefine trials back to bursts 
    cfg = [];
    cfg.trl                        = trlold;
    dataset3                       = ft_redefinetrial(cfg, dataset2);

    cfg = [];
    cfg.method                       = 'pchip'; % Here you can specify any method that is supported by interp1: 'nearest','linear','spline','pchip','cubic','v5cubic'
    cfg.prewindow                    = 0.001; % Window prior to segment to use data points for interpolation
    cfg.postwindow                   = 0.001; % Window after segment to use data points for interpolation
    cfg.feedback                     = 'yes';
    dataset4                         = ft_interpolatenan(cfg,dataset3);  

    dataset4.trialinfo(1:length(dataset4.trial),1) = SbjINFO(SUBJ).Blocks(SESS,i);

    switch i
        case 10
            eval(['b',num2str(i),'=dataset4;'])
        otherwise
            eval(['b0',num2str(i),'=dataset4;'])
    end


    clear  cfg cfg_ringing artifact_ringing cfg_artifact dataset comp_decay st k comp_d cc dd comp_d_avg...
        artcomp W Wm source ii sourcesig I dataset2 new_name dataset3 dataset4
    i=i+1;     
end
close all

%% Append blocks to one dataset and save it
% Change sampleinfo for blocks:
for bl=2:10
    switch bl
        case 2
            filename        = 'b02'; 
            t               = size(b01.sampleinfo,1);
            b02.sampleinfo  = b02.sampleinfo + b01.sampleinfo(t,2);
            previous        = filename;
        case 10
            filename        = 'b10';
            eval(['t=size(',previous,'.sampleinfo,1);']);
            eval([filename,'.sampleinfo=',filename,'.sampleinfo+',previous,'.sampleinfo(t,2);']);
        otherwise
            filename        = fullfile(['b0',num2str(bl)]);
            eval(['t=size(',previous,'.sampleinfo,1);']);
            eval([filename,'.sampleinfo=',filename,'.sampleinfo+',previous,'.sampleinfo(t,2);']);
            previous        = filename;
    end
end

cfg = [];
data_app   = ft_appenddata (cfg, b01, b02, b03, b04, b05, b06, b07, b08, b09, b10);

cfg=[];
cfg.resamplefs                   = 1250;
cfg.demean                       = 'yes';
data_raw                         = ft_resampledata(cfg,data_app);

save ([OutputDir, 'p09s3_raw'], 'data_raw')
