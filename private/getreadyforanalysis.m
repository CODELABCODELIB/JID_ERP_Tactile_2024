function INEEG = getreadyforanalysis(INEEG,bandpassrange,eyeE,epochevent,epochwindow,baselinewindow,rejepoch)

% To generate clean eeg data
% --------------------------Usage-------------------------------------
% fomula: INEEG = getreadyforanalysis(INEEG,bandpassrange,eyeE,epochevent,epochwindow,baselinewindow,rejepoch)
% Input(s):
%   -INEEG: EEG struct from one participant;
%   -bandpassrange:like [0.1 45]Hz;
%   -eyeE:  eye electrode, {'E5' 'E64'};
%   -epochevent: {'S 33' 'S 34' 'S 36' 'S 40'}
%   -epochwindow: [-0.4 0.5]S
%   -baselinewindow: [-400 -200]ms
%   -rejepoch: 0=no rejection; 1= reject trials >80 or <-80 uV
% Output(s):
%   -INEEG struct
% Requires:
%   -runICA
% Will do:
%   -rejeact eyeblinks
%   -refiltering
%   -intepolate
%   -epoch
%   -re-reference
%   -remove baseline
%   -reject epoch
% Author: Wenyu Wan(万文雨), Leiden Univeristy
% Date: 08/03/2023
% edited at 24/08/2023; 27/11/2023


% remove blinks and modify EEG.event with only those events which are in 'passive movie condition'
if ~isempty(eyeE)
INEEG           = rejecteyeblink(INEEG,eyeE);
end

%filtering
if ~isempty(bandpassrange)
INEEG           = pop_eegfiltnew(INEEG, [],bandpassrange(2));
INEEG           = pop_eegfiltnew(INEEG, bandpassrange(1),[]);
end

% interpolate
if ~isfield(INEEG,'Orignalchanlocs')
load('Orignalchanlocs.mat');
INEEG.Orignalchanlocs = Orignalchanlocs;
end
INEEG           = pop_interp(INEEG,INEEG.Orignalchanlocs,'spherical');

% remove unrelated channels
if ~isempty(eyeE)
INEEG           = pop_select(INEEG,'nochannel',eyeE); %eyeE
end

% epoch, select epoch, and reject epoch according to the intervals
if ~isempty(epochevent)
INEEG           = pop_epoch(INEEG,epochevent,epochwindow,'epochinfo','no');
end

%re-refernce
INEEG           = pop_reref (INEEG, [1:62], 'keepref', 'on');

%baseline correction
if ~isempty(baselinewindow)
INEEG           = pop_rmbase(INEEG, baselinewindow); %
end

% reject trails?
if rejepoch==1
[INEEG Indexes] = pop_eegthresh(INEEG, 1, [1:62], -80, 80, -0.2, 1, 0, 1);
end

% create INEEG.modepoch to store the epoch after running selectepoch
if ~isempty(epochevent)
INEEG           = selectepoch (INEEG);
end

% check dataset
INEEG           = eeg_checkset(INEEG);
end

