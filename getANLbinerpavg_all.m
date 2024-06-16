function [binerpavg_all] = getANLbinerpavg_all(data_path,out_path,targetE,video,type,timerange)
%function getANLbinerpavg_all(data_path,out_path,targetE)
% data_path:  the path parent folder stored individual's bnerpavg data
% out_path : the path you would like to store the results
% targetE:  {'S  1'}, {'S  2'},{'S  4'}
% video: 1= generate JID-ERP video; 0=no video;
% type 0: all participant
% type 1: remove unhealty participant
% type 2: remove unhealty & small brain response participant

addpath (genpath('/home/wanw1/toolbox/eeglab2021'));
addpath (genpath('/home/wanw1/toolbox/OneEEG'));

% data_path  = '/data1/wanw1/ANLpassive4/binerpavg';
% out_path   = '/data1/wanw1/ANLpassive4/binerpavg_all';
mkdir(out_path);
% targetE    = {'S  4'};

% directory of sublist
listing     = dir(data_path);
folderNames = {listing([listing.isdir]).name};
subIDlist   = folderNames(~cellfun(@isempty,regexp(folderNames,'aaaa*')));

for sub      = 1: length(subIDlist)
    sub_path = strcat(data_path,'/',subIDlist{sub},'/',targetE{1});
    cd(sub_path);
    load('bineravg.mat');
    binerpavg_all(sub,:,:) = binerp_avg;
    binerpstd_all(sub,:,:) = binerp_std; 
    binerpn_all(sub,:)     = binsetup.n';
    erpavg_all(sub,:,:)    = erp_avg;
    erp_maxchann(sub,:)    = binsetup.chan;
end
binsetup       = binsetup;
binsetup       = rmfield( binsetup , {'n','erp','chan'} ) ;
binsetup.N     = NaN(size(binsetup.N));

outdir         = strcat(out_path,'/',targetE{1});
mkdir(outdir);
cd (outdir)
save('binerpavg_all.mat','binerpavg_all','binerpstd_all','binerpn_all','erpavg_all','binsetup','subIDlist','erp_maxchann');

if type == 1 || type ==2
[subIDlist_include]= excludeparticipant(type,erpavg_all,subIDlist,binsetup,timerange)
loc_tmp = ismember(subIDlist,subIDlist_include);
binerpavg_all(~loc_tmp,:,:)=[];
binerpstd_all(~loc_tmp,:,:) = []; 
binerpn_all(~loc_tmp,:)     = [];
erpavg_all(~loc_tmp,:,:)    = [];
erp_maxchann(~loc_tmp,:)     = [];
else
    subIDlist_include       = subIDlist;
end
save('binerpavg_all.mat','binerpavg_all','binerpstd_all','binerpn_all','erpavg_all','binsetup','subIDlist_include','erp_maxchann');

if video==1
getpopolationvideo(binerpavg_all,erpavg_all)
end

end