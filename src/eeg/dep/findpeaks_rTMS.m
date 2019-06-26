function [trl, event] = findpeaks_rTMS(cfg)
% From 'Weak electric fields induce neural entrainment in humans'
% by E. Zmeykina
%
% Script defines the events (TMS pulse location) for analysis of rTMS-EEG
%
% USE AS: [cfg] = ft_definetrial(cfg);
% 
% Configuration should contain:
% cfg.dataset                      = files_hdr(i).name;
% cfg.eegdata                      = files_eeg(i).name;
% cfg.trialdef.eventtype           = 'TMSburst'; - for the whole trial (In exp1&pilot data: Burst from -5 to 5 sec around TMS)
% cfg.trialdef.eventvalue          = 'S  2';
% cfg.trialdef.eventtype2          = 'TMSpulse'; - Each pulse's onset
% cfg.trialdef.eventvalue2         = 'S  3';
% cfg.trialdef.pulseperburst       = 20; Number of pulses per burst. (In exp1&pilot data: 20) 
%
% Parameters for burst onset:
% cfg.trialdef.fixedpulse        = 'first' for analisys of trial with the
% first fixed pulse; 'last' - with the last fixed pulse in burst; 
% cfg.trialdef.prestim and poststim should be changed accordingly: 
% - 'Bonset' 
% cfg.trialdef.prestim             = -2;
% cfg.trialdef.poststim            = 4;
% - 'Boffset' 
% cfg.trialdef.prestim             = -4;
% cfg.trialdef.poststim            = 2; 

hdr          = ft_read_header(cfg.dataset);
event        = ft_read_event(cfg.dataset);
eeg_file     = ft_read_data(cfg.eegdata);
Npulperbur   = cfg.trialdef.pulseperburst;

%% Define channel with the highest peak
[Max,I1]=max(detrend(eeg_file(:)));
[Min,I2]=min(detrend(eeg_file(:)));

if abs(Max)>abs(Min)
    [trig_numb, ~] =ind2sub(size(eeg_file), I1);
    trig_data    = detrend(eeg_file(trig_numb, :));
else
    [trig_numb, ~] =ind2sub(size(eeg_file), I2);
    trig_data    = detrend(eeg_file(trig_numb, :))*(-1);
end

%% Alternative trigger channel definition 1
% 
% trig_numb = 46;
% trig_data    = detrend(eeg_file(trig_numb, :));
%
% %Alternative trigger channel definition 2
% 
% [Max,I1]       = max(detrend(eeg_file(:)));
% [trig_numb, ~] = ind2sub(size(eeg_file), I1);
% trig_data      = detrend(eeg_file(trig_numb, :));
%%
% Find peak values in the triger channel higher than 'tresh'
tresh  = max(trig_data)/3;
[~,locs]   = findpeaks(trig_data, 'MinPeakHeight', tresh);
pulse = locs-4;

% Set the event for burst onset/offset
switch cfg.trialdef.trialonset
    case 'first'
    burst = pulse(1:Npulperbur:end);
    case 'last'
    burst = pulse(20:Npulperbur:end);
end

% Plot and check data events
%     plot (trig_data) 
%     hold on
%     plot(burst,(trig_data(burst)),'r x')
%     hold on
%     plot(pulse,(trig_data(pulse)),'b o')

% Create variable with sample number of each TMS pulse, N=500
s=1;
for l = 1:length(pulse)
        evnt(l).type     = 'TMSpulse'; 
        evnt(l).value    = cfg.trialdef.eventvalue2;
        evnt(l).duration = 1;
        evnt(l).offset   = [];
        evnt(l).sample   = pulse(s);
        s=s+1;
end

% Create variable with sample number of each TMS burst, N=25
n=1;
a=length(evnt);
for l=a+1:a+length(burst)
        evnt(l).type     = 'TMSburst'; 
        evnt(l).value    = cfg.trialdef.eventvalue;
        evnt(l).duration = 1;
        evnt(l).offset   = [];
        evnt(l).sample   = burst(n);
        n=n+1;
end

% Sort structure by sample 
[event , ~] = nestedSortStruct(evnt, 'sample');
sample = [event(strcmp(cfg.trialdef.eventvalue, {event.value})).sample]';

pretrig  = round(cfg.trialdef.prestim  * hdr.Fs);
posttrig =  round(cfg.trialdef.poststim * hdr.Fs);

% Create trl
trl =[];
for k = 1:length(sample)
    trlbegin = sample(k) + pretrig;       
     trlend   = sample(k) + posttrig;       
     offset   = pretrig;
     newtrl   = [trlbegin trlend offset];
     trl      = [trl; newtrl];
end  
