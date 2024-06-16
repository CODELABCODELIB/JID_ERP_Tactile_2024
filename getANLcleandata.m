function getANLcleandata(subID,data_path,out_path,bandpassrange,eyeE,epochevent,epochwindow,baselinewindow,rejepoch) 
% To generate ANL clean eeg data based on getreadyforanalysis
% --------------------------Usage-------------------------------------
% fomula: INEEG = getANLcleandata(subID,data_path,out_path,bandpassrange,eyeE,epochevent,epochwindow,baselinewindow,rejepoch)
% for example: getANLcleandata(subID,data_path,out_path,[1 45],{'E5' 'E64'},{'S  1' 'S  2' 'S  4'},[-0.2 0.3],[-200 -50],1);
% Input(s):
%   -subID: 'aaaaaa**'
%   -data_path: the path stored the folder of subID datasets
%   -out_path: the path you want to store the subID result folder
%   -bandpassrange:like [0.1 45]Hz;
%   -eyeE:  eye electrode, {'E5' 'E64'};
%   -epochevent: {'S 33' 'S 34' 'S 36' 'S 40'}
%   -epochwindow: [-0.4 0.5]S
%   -baselinewindow: [-400 -200]ms
%   -rejepoch: 0=no rejection; 1= reject trials >80 or <-80 uV

% Output(s):
%   -EEG dataset
% Requires:
%   -runICA
% Will do for each datasets, will do:
%   -rejeact eyeblinks
%   -refiltering
%   -intepolate
%   -epoch
%   -re-reference
%   -remove baseline
%   -reject epoch
% Author: Wenyu Wan(万文雨), Leiden Univeristy
% Date: 08/03/2023
% edited at 27/11/2023


 EEG_path     = data_path; %'/Users/wandakeai/Documents/data/pre_status';
 Subject_name = subID;
 outpath      = out_path; %'/Users/wandakeai/Documents/data/pre_status_testing';
 cd(strcat(EEG_path,'/',subID)) 
 load('Status.mat');

% load dataset and do preprocessing analysis;
for datasetlist        = 1: size(eeg_name,2)
        decidepassive  = strcmp({eeg_name(datasetlist).urevent.code},'Stimulus');
        if sum(decidepassive)>50 %more than 50 trials
        % load dataset
        eegset_pathtmp = strcat(EEG_path,'/',Subject_name);
        eegset_nametmp = strcat(eeg_name(datasetlist).processed_name,'.set');
        INEEG          = pop_loadset('filename',eegset_nametmp, 'filepath',eegset_pathtmp);
        % get clean data
        % INEEG          = getreadyforanalysis(INEEG,[1 45],{'E5' 'E64'},{'S  1' 'S  2' 'S  4'},[-0.2 0.3],[-200 -50],1);
        INEEG = getreadyforanalysis(INEEG,bandpassrange,eyeE,epochevent,epochwindow,baselinewindow,rejepoch);
        outdir         = strcat(outpath,'/',Subject_name);
        if ~exist(outdir);
        mkdir(outdir);
        end
        % save dataset
        INEEG          = pop_saveset(INEEG,'filename',eegset_nametmp,'filepath',outdir,'version','7.3');
        else
        end
end
end