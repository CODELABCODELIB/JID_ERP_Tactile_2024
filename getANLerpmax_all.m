
addpath (genpath('/home/wanw1/toolbox/eeglab2021'));
addpath (genpath('/home/wanw1/toolbox/OneEEG'));

data_path = '/data1/wanw1/ANLpassive/erpavg';
out_path  = '/data1/wanw1/ANLpassive/erpall';
targetE   = {'S  1'};
clear all;

% directory of sublist
listing     = dir(data_path);
folderNames = {listing([listing.isdir]).name};
subIDlist       = folderNames(~cellfun(@isempty,regexp(folderNames,'aaaa*')));

for sub = 1: length(subIDlist)
    path_tmp = strcat(data_path,'/',subIDlist{sub},'/',targetE{1});
    cd (path_tmp);
    load('erpavg.mat','erp_maxchann','maxchann')
    erpmax_all(sub,:,:)= nanmean(erp_maxchann(:,:),2);
    maxchan_all(sub)= maxchann;
end
cd(strcat(out_path,'/',targetE{1}));
save(strcat('erpmax_all_',targetE{1},'.mat'),'erpmax_all','maxchan_all','subIDlist')