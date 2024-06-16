function [subIDlist_include]= excludeparticipant(type,erpavg_all,subIDlist,binsetup,timerange)
% input: 
% type: type0 = no exclude; type1 = exclude unhealthy sub; type2 = exlude
% unhealthy & 10% small brain response sub
% erpavg: sub*maxchan*frame
% subIDlist : all participant list

% output
% locs : the indx of exclude subID

if type ==1 || type ==2
    load ('subID_unhealthy.mat');
    locs = ismember(subIDlist,subID_unhealthy);
    subIDlist_include = subIDlist(~locs);
    if type ==2
        erpavg_new = erpavg_all(~locs,:);
        indx_0 = find(binsetup.times==0);
        [~,I]= sort(max(erpavg_new(:,indx_0+timerange(1):indx_0+timerange(2)),[],2),'ascend')
        exclude_numb      = ceil(size(subIDlist_include,2)*0.1);
        subIDlist_tmp = subIDlist_include(I(1:1:exclude_numb));
        subIDlist_exclude = [subIDlist_tmp,subID_unhealthy];
        locs = ismember(subIDlist,subIDlist_exclude);
        subIDlist_include = subIDlist(~locs);
    end
else
    subIDlist_include = subIDlist;
end
end
