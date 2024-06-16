function [erpavg_all,erpmax_all] = getANLerpavg_all(data_path,out_path,targetE)

% to get a population matrix of all subjects
% input:
% - data_path: the path stored all sub folder
% - out)path: the path will be stored the population matrix
% - targetE: the condition you target, like '{S  1}'
% output:
% - erp_all:sub*chann*frame
% - maxchan_all: sub*chan(the channel that have the maximum first postive peak value)
% - erpmax_all: sub*frame;
% - subIDlist: subID list
% Author: Wenyu Wan(万文雨), Leiden Univeristy & Uva
% Date: 18/08/2023
% Edited: 27/11/2023

% add toolbox
addpath (genpath('/home/wanw1/toolbox/eeglab2021'));
addpath (genpath('/home/wanw1/toolbox/OneEEG'));

% directory of sublist
listing     = dir(data_path);
folderNames = {listing([listing.isdir]).name};
subIDlist       = folderNames(~cellfun(@isempty,regexp(folderNames,'aaaa*')));

for sub = 1: length(subIDlist)
    load( strcat(data_path,'/',subIDlist{1,sub},'/',targetE{1},'/erpavg.mat'));
    erpavg_all(sub,:,:)   = erp_avg;
    maxchan_all(sub,:) = maxchann;
    erpmax_all(sub,:)= nanmean(erp_maxchann,2);
end
outdir2         = strcat(out_path,'/',targetE{1});
mkdir(outdir2);
cd (outdir2)
save('erpavg_all.mat','erpavg_all','erpmax_all','maxchan_all','subIDlist');

end