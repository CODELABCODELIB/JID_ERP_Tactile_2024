function getANLbinerp(subID,data_path,out_path,targetE,relativeE,chann,n,edge)
% To generate binerp and video of one condition for one particpant
% --------------------------Usage-------------------------------------
% fomula: 

% Input(s):
%   - subID: folder's name, like 'AT08'
%   - data_path: the path of whole datasets
%   - out_path: the path of output results
%   - targetE: The Event in focus. For instance {'S  32'}
%   - relativeE: The Events based on which the intervals will be estimated can be the same as TargetE or other events such as {'S  32', 'S  33'}
%   - Video: 1= generate video; 0= no video;



% Output(s):
%   - binerp: 
%   - binsetup: some parameter of binerp
%     - binsetup.Xedges: the edges [S] of Kth pre-interval when bin
%     - binsetup.Yedges: the edges [S] of (K-1)th pre-interval when bin
%     - binsetup.binmatrix: n*3 matrix. binmatix(n,1)=the original X bin
%     number; binmatix(n,2)=the original Y bin number; binmatix(n,3)=the
%     new XY bin number;
%     - binsetup.n: n*1 matrix. trials' counts for n bin.
%     - binsetup.times: INEEG.times
%     - binsetup.N: N(X)*N(Y) matrix. trials' counts for each bin.
%     - binsetup.chan: the choosed chann 
%     - binsetup.erp: [times* trails] the erp data of chann

%   - Video: if video=1, then will store .avi video

% Requires:
%   - getbinerp()
%   - getbinvideo()


% Author: Wenyu Wan(万文雨), Leiden Univeristy
% Date: 18/08/2023


sub_path    = strcat(data_path,'/',subID,'/');
cd (sub_path)
set_list    = dir('*.set');

set_listnew = extractBefore({set_list.name},'.set');

%if sub have more than 1 file
for i=1:length(set_list)
setpath_tmp      = strcat(set_list(i).folder,'/',set_list(i).name);
INEEG            = pop_loadset(setpath_tmp);

% get chann if N(set)>2
%if isempty(chann) & length(set_list)>1
%[chann]          = getchann(subID,data_path,targetE,'right');
%else
%end
% get the indx of target event
%Stim        = strcmp({INEEG.modepoch.eventtype}, targetE);

% getbinerp
[binerp,binsetup]= getbinerp(INEEG,chann,targetE,relativeE,0,[0 0.5 1 2 4 8]);
%[binerp,binsetup]= getbinerp(INEEG,rejepoch,targetE,relativeE,n,edge);


outdir         = strcat(out_path,'/',subID,'/',targetE{1});
if ~exist(outdir);
    mkdir(outdir);
end
filename_tmp   = strcat(outdir,'/',set_listnew{i},'_binerp.mat');
save (filename_tmp ,'binerp', 'binsetup');

end

% if video==1
% cd(outdir)
% [binerp_avg] = getbinerpvideo(subID,10,[-100 300],binerp,binsetup,'nanmean');
% %[binerp_avg] = getbinerpvideo(subID,minN,timerange,binerp,binsetup)
% save (strcat(outdir,'/binerp.mat') ,'binerp_avg','-append')
% else
%      return
% end

end

