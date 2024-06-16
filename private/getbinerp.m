 function [binerp,binsetup]= getbinerp(INEEG,chann,targetE,relativeE,n,edges)
% To generate inhibition status for each trail based on the timeseries
% --------------------------Usage-------------------------------------
% fomula: [binerp,binsetup]= getbinerp(INEEG,rejepoch,chann,targetE,relativeE,n,edges)
% Input(s):
%   -INEEG: EEG struct from one participant
%   -rejepoch: 0=no reject; 1= reject according to voltage threshold;
%   - targetE: The Event in focus. For instance {'S  32'}
%   - relativeE: The Events based on which the intervals will be estimated can be the same as TargetE or other events such as {'S  32', 'S  33'}
%   - n: the minmum trials number for bin
%   - binsize: the size of each bin [s]
%   - interval_threshold: the threshold of interval
% Output(s):
%   - binerp: 1*N cells. each cell for each bin. [times*trials]
%   - binsetup
% Requires:
%   - getbin()
%   - selectelectrode()
%   - eeglab toolbox
%   - SensoryAdptation toolbox


% % reject trails
% if rejepoch ==1
% [INEEG Indexes]= pop_eegthresh(INEEG, 1, [1:62], -80, 80, -0.2, 1, 0, 1); % other method
% elseif rejepoch ==0
% end
% 
% INEEG       = selectepoch(INEEG);

% get the indx of target event
Stim        = strcmp({INEEG.modepoch.eventtype}, targetE);

% get bin
[bin_indx, bin_matrix,Xedges,Yedges,N_new,N] = getbinidx(INEEG,targetE,relativeE,Stim,edges);

% choose electrode
% [chann]        = selectelectrode(INEEG,targetE);
if isempty(chann)
%[chann]     = selectelectrode(INEEG,Stim, targetE);
[chann]      = selectelectrode(INEEG.data,INEEG.times,INEEG.Orignalchanlocs,Stim,'middle');
else
end

% get the targetE erp of choosed electrode
data_erp       = INEEG.data;
data_erpnew    = squeeze(data_erp(chann,:,Stim));

% get binerp 2D
binerp{1,size(N_new,1)} = [];
[N_loc]  =  find(N_new>n);
for i = 1:length(N_loc)
   trial_idx          = find(bin_indx==N_loc(i));
   binerp{1,N_loc(i)} = data_erpnew(:,trial_idx);
end

% get binerp according to pre-interval(xindx)


% get binerp according to pre-pre interval


% store parameters?
% 
binsetup.Xedges    = Xedges;
binsetup.Yedges    = Yedges;
binsetup.binmatrix = bin_matrix;
binsetup.n         = N_new;
binsetup.times     = INEEG.times;
binsetup.N         = N;
binsetup.chan      = chann;
binsetup.erp       = data_erpnew;

end