      function [bin_indx, bin_matrix,Xedges,Yedges,N_new,N]=getbinidx(INEEG,targetE,relativeE,Stim,edges)
% To generate new bin number for each trials
% --------------------------Usage-------------------------------------
% fomula: 

% Input(s):
%   - INEEG: EEG struct from one participant
%   - targetE: The Event in focus. For instance {'S  32'}
%   - relativeE: The Events based on which the intervals will be estimated can be the same as TargetE or other events such as {'S  32', 'S  33'}
%   - Stim: N (trails)*1 martrix of the logical value;  1=targetE, 0= no target
%   - edges: [0:0.5:1 2 3 10]
%   - binsize: the size of each bin [s]
%   - interval_threshold: the threshold of interval


% Output(s):
%   - bin_indx: the new bin number for each trials, [n*1],n=N(trials)
%   - bin_matrix: bin_matrix(:,1)=binX; bin_matrix(:,2)=binY;
%   bin_matrix(:,3)=binXY
%   - N: how many trials for each bin

% Requires:
%   - getintervaldynamics()


% Author: Wenyu Wan(万文雨), Leiden Univeristy
% Date: 18/08/2023


% get preinterval, pre-pre interval, and erp data for target event
[intk, intk_1]      = getintervaldynamics(INEEG, targetE, relativeE);
pre_interval1_tmp   = intk(Stim)/1000;
pre_interval2_tmp   = intk_1(Stim)/1000;
% data_erp_tmp        = squeeze(data_erp(15,:,Stim));%elctrode=15


% reject deviation trails according to interval>10s
% deviation_interval1 = find (pre_interval1_tmp>interval_threshold);
% deviation_interval2 = find (pre_interval2_tmp>interval_threshold);
% pre_interval1_tmp(deviation_interval1) = nan;
% pre_interval2_tmp(deviation_interval2) = nan;


% get bin indx for each trial
%[N,Xedges,Yedges,binX,binY] = histcounts2(pre_interval1_tmp,pre_interval2_tmp,[0:binsize:interval_threshold], [0:binsize:interval_threshold]);
[N,Xedges,Yedges,binX,binY] = histcounts2(pre_interval1_tmp,pre_interval2_tmp,edges,edges);
% N(i,j) counts the value [X(k),Y(k)] if Xedges(i) ≤ X(k) < Xedges(i+1) and Yedges(j) ≤ Y(k) < Yedges(j+1).
gridx    = size(N,1);
gridy    = size(N,2);
[x, y]   = meshgrid(1:gridx, 1:gridy);
x        = x(:);
y        = y(:);

binXY    = 1:1:size(N,1)*size(N,2);
binXY    = binXY';
bin_matrix = [x y binXY];

bin_orig   = [binX;binY]';

[Lia,bin_indx] = ismember(bin_orig,bin_matrix(:,1:2),'rows');
N_tmp              = N';
N_new              = reshape (N_tmp,[],1)
end