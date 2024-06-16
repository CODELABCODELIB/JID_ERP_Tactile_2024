function [binerp_avg,erp_avg,binerp_std,binsetup] = getbinerpavg(binerp,binsetup,minN,method)
% To generate binerp for one particpant
% --------------------------Usage-------------------------------------
% fomula: [binerp_avg,erp_avg,binsetup] = getbinerpavg(binerp,binsetup,minN,method)
% Input(s):
%   - subID: the folder's name for one participant, like 'AT08';
%   - data_path: the path of whole participant. each sub's folder contain
%   .mat file which has 'binerp','binsetup';
%   - minN: the minmum n for each bin, like 5,10, 15;
%   - method: 'nanmean','nanmedian', or 'trimmean'
% Output(s):
%   - binerp_avg: 1*bins cell, each cells is [times*trials] matrix for the picked
%   electrode;
%   - binsetup: a struct
%     - binsetup.Xedges: the bin's edges of pre-interval
%     - binsetup.Yedges: the bin's edges of pre-pre-interval
%     - binsetup.binmatrix: (:,1) is binnumber of X; (:,2) is  binnumeber of Y; (:,3) is binnumber of XY. 
%     - binsetup.n: [bins*1]trails' number for each bin orgized by the reshaped bin
%     - binsetup.times: = INEEG.times     
%     - binsetup.chan: the picked electrode
%     - binsetup.erp: [times*trails]the erp data for the picked electrode
% Will do:
%   - merge the outputs if there has more than one '.mat' file
%   - nan bin whose n(trails)<minN, 
%   - get a desciptive statistic result, for one participant
% Author: Wenyu Wan(万文雨), Leiden Univeristy
% Date: 23/08/2023

% nan bin whose n< minN
[N_small]  =  find(binsetup.n<minN);
binerp(N_small) = {nan(length(binsetup.times),1)};

% reorganize binerp
empty_idx = cellfun(@isempty,binerp);
binerp(empty_idx) = {nan(length(binsetup.times),1)};
if strcmp(method,'nanmean')
    binerp_avg        = cellfun(@(x) nanmean(x,2),binerp,'un',0);
elseif strcmp(method,'nanmedian')
    binerp_avg        = cellfun(@(x) nanmedian(x,2),binerp,'un',0);
elseif strcmp(method, 'trimmean')
    binerp_avg        = cellfun(@(x) trimmean(x,20,2),binerp,'un',0);
end
erp_avg           = mean(binsetup.erp,2);
binerp_avg        = cellfun(@double,binerp_avg,'UniformOutput',false);
binerp_avg        = cell2mat(binerp_avg);

% varience
binerp_std        = cellfun(@(x) std(x,0,2),binerp,'un',0);
binerp_std        = cellfun(@double,binerp_std,'UniformOutput',false);
binerp_std        = cell2mat(binerp_std);

%binerp_cv         = binerp_std./binerp_avg;

end
