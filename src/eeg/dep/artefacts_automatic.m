function [dataset_out, arttrial2, artchan, ChanWithLargeSTD] = artefacts_automatic(data_in, neighbours)
%Prepare datasets
Cell_data       =   data_in.trial;
EEG.data        =   cat(3,data_in.trial{1,:});
EEG.times       =   data_in.time{1,1};
EEG.nbchan      =   63;
chanthr         =   12; % 20% of total number of channels
time            =   (EEG.times >=-5 | EEG.times <= 2);
alltrial        =   1:size(data_in.trial,2);

%% Find trials with outlier power values (based on quartiles). ROUND1 - interpolate

trialpow        = squeeze(mean(EEG.data(:,time,:).^2,2));
outliers        = isoutlier(trialpow, 'quartiles', 2); 
artchannum      = repmat(sum(outliers, 1), size(EEG.data, 1), 1);
[chan, trial]   = find(outliers & (artchannum <= chanthr)); % only interplate trials with less than 12 noisy electrodes. Otherwise simply discard
interptrial     = unique(trial); %trials to be repaired

% Interpolate channels on outlier trials with <=12 (chanthr) noisy electrodes
for kk = 1:length(interptrial)
    artind = (trial == interptrial(kk));
    
    cfg = [];
    cfg.trials = interptrial(kk);
    EEGarttr   = ft_selectdata (cfg,data_in);
    
    cfg = [];
    cfg.badchannel                   = EEGarttr.label(chan(artind));
    cfg.layout                       = 'actiCAP_64_layout.mat';
    cfg.method                       = 'weighted';
    cfg.neighbours                   = neighbours;
    EEGarttr                         = ft_channelrepair(cfg, EEGarttr);
    
    EEG.data(:, :, interptrial(kk)) = cell2mat(EEGarttr.trial);  
    Cell_data(interptrial(kk)) = squeeze(EEGarttr.trial);
    
    clear EEGarttr
end
%% Find trials to be discarded. ROUND2 - discard

trialpow        = squeeze(mean(EEG.data(:,time,:).^2,2));
outliers        = isoutlier(trialpow, 'quartiles', 2); 
artchannum      = repmat(sum(outliers, 1), size(EEG.data, 1), 1);

[~, trial] = find(outliers & (artchannum >chanthr)); 
arttrial = unique(trial)';

goodtrials  = setdiff(alltrial ,arttrial);
data        = data_in;
data.trial  = Cell_data; % update trials with interpolated channels
data.trialinfo (interptrial,2) = 1;

cfg=[];
cfg.trials = goodtrials;
data_r2      = ft_selectdata (cfg, data); % remove bad trials

%% FIND SINGLE BAD ELECTRODES (low correlation with neighbours)
artchan = [];

EEG.data = cat(3,data_r2.trial{1,:});
EEG.label = data_r2.label;
thr = 0.05; % 5% of epochs in which channel was bad

% MAXCORR
    % Find the maximum correlation of each electrode with its neighbors
    maxcorr = zeros(1, size(EEG.data, 1));
    maxcorrwin = zeros(size(EEG.data, 1), size(EEG.data, 3));
    times = find((EEG.times <= 4));
    corrall = zeros(size(EEG.data, 1), size(EEG.data, 1), size(EEG.data, 3));
    
    for jj = 1:size(EEG.data, 3)
        corrall(:, :, jj) = real(corrm(squeeze(EEG.data(:,times,jj)), squeeze(EEG.data(:,times,jj))));
    end
    
    x = EEG.label;

    for c=1:size(EEG.data, 1)
        for jj = 1:size(EEG.data, 3)
            xx =find(ismember(x, neighbours(c).neighblabel)==1)';
            maxcorrwin(c, jj) = prctile(corrall(c, xx, jj), 99);
        end
        maxcorr(c) = sum(maxcorrwin(c,:) < 0.4)/size(EEG.data, 3);
    end 
    
artchan = unique([artchan find(maxcorr>thr)]);

% STD ACROSS EPOCHS IS HIGH
datTmp          = squeeze(nanmean(abs(EEG.data),2));
ChanWithLargeSTD = find(nanstd(datTmp')>30);


if length([artchan ChanWithLargeSTD])<10 
    cfg = [];
    cfg.badchannel                   = EEG.label(unique([artchan ChanWithLargeSTD]));
    cfg.layout                       = 'actiCAP_64_layout.mat';
    cfg.method                       = 'weighted';
    cfg.neighbours                   = neighbours;
    data_r3                          = ft_channelrepair(cfg, data_r2);
else 
 disp (['WARNING: BAD CHANS NOT REPAIRED. Too many chans with low(<0.4) corr and high STD']);   
end

%% Find trials to be discarded. ROUND3 - only display
EEG.data         =   cat(3,data_r3.trial{1,:});
trialpow         = squeeze(mean(EEG.data(:,time,:).^2,2));
outliers         = isoutlier(trialpow, 'quartiles', 2); 
artchannum       = repmat(sum(outliers, 1), size(EEG.data, 1), 1);

[~, trial] = find(outliers & (artchannum >12)); 
arttrial2 = unique(trial);

cfg=[];
cfg.trials       = setdiff (1:length(data_r3.trial), arttrial2);
dataset_out      = ft_selectdata (cfg, data_r3);
 
%  %Print outcome:
% subplot 311
% imagesc(outliers)
% hold on
% subplot 312
% imagesc(outliers)
% subplot 313
% imagesc(outliers3)
% 
% 
% figure 
% subplot 311
% imagesc(trialpow)
% hold on
% subplot 312
% imagesc(trialpow)
% subplot 313
% imagesc(trialpow3)
%  
 
 if ~isempty(ChanWithLargeSTD)
    disp(['WARNING: Channels with high (>30uV) STD: ' num2str(ChanWithLargeSTD)]);pause(2)
 end
 disp (['WARNING: Channels with low (<0.4) correlation: ' num2str(artchan)]);
 disp (['WARNING: Artefactual trials: ' num2str(arttrial2')]);
  
end