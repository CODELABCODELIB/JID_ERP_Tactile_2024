function [binerp_avg,erp_avg,binsetup] = getANLbinerpavg(subID,data_path,out_path,targetE,minN,method,video)
% To generate binerp for one particpant
% --------------------------Usage-------------------------------------
% fomula: 

% Input(s):
%   - subID: the folder's name for one participant, like 'AT08';
%   - data_path: the path of whole participant. each sub's folder contain
%   .mat file which has 'binerp','binsetup';
%   - minN: the minmum n for each bin, like 5,10, 15;
%   - method: 'nanmean','nanmedian', or 'trimmean'
%   - video: 1= generate video; 0= no video
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

sub_path     = strcat(data_path,'/',subID,'/',targetE{1});
cd (sub_path)
mat_list     = dir('*.mat');

outdir         = strcat(out_path,'/',subID,'/',targetE{1});
if ~exist(outdir);
    mkdir(outdir);
end

%set struct and variables
tmp_binerp       = cell.empty(0,25);
tmp_binsetup.n   = double.empty(0,25);
tmp_binsetup.erp = single.empty(500,0);

%     tmp_binerp   = cell(size(binerp,1),size(binerp,2)); % 
%     tmp_binsetup = struct('Xedges',[],'Yedges',[],'binmatrix',[],'n',[],'times',[],'N',[],'chan',[],'erp',[]);%
    %tmp_binsetup = struct('Xedges',[],'Yedges',[],'binmatrix',[],'n',zeros(64, 1),'times',[],'N',zeros(8,8),'chan',[],'erp',[]);
for i = 1:length(mat_list)
    load(mat_list(i).name)
    tmp_binerp = [tmp_binerp;binerp];
    tmp_binsetup.n         = [tmp_binsetup.n,binsetup.n];
    tmp_binsetup.erp       = [tmp_binsetup.erp,binsetup.erp];
end
tmp_binsetup.times     = binsetup.times;
tmp_binsetup.chan      = binsetup.chan;
tmp_binsetup.Xedges    = binsetup.Xedges;
tmp_binsetup.Yedges    = binsetup.Yedges;
tmp_binsetup.binmatrix = binsetup.binmatrix;
tmp_binsetup.N         = binsetup.N;
clear binerp binsetup

for m = 1: length(tmp_binerp)
    binerp{m}              = [tmp_binerp{:,m}];
    
end
binsetup               = tmp_binsetup;
binsetup.n             = [];
binsetup.n             = sum(tmp_binsetup.n,2);



% if mat_list=1, just load the .mat file
[binerp_avg,erp_avg,binerp_std,binsetup] = getbinerpavg(binerp,binsetup,minN,method);

filename_tmp   = strcat(outdir,'/bineravg.mat');
save (filename_tmp ,'binerp_avg','erp_avg','binerp_std','binsetup');

if video ==1
% generate video
cd (outdir)
getbinerpvideo(subID,minN,[-200 299],binerp_avg,erp_avg,binsetup,method,binerp_std,targetE)
end
% nan bin whose n< minN
end
