function [erp_avg,maxchann]=getANLerpavg(subID,data_path,out_path,targetE,ROI,timewindow,ploterptop,frame);

% ROI: 'right','left','middle'
% frame: how many timepoints, like 500
% output:
% erp_avg(1,:,:) == S1
% erp_avg(1,:,:) == S2
% erp_avg(1,:,:) == S4

% list all of set
sub_path    = strcat(data_path,'/',subID,'/');
cd (sub_path)
set_list    = dir('*.set');
% set outdir
outdir         = strcat(out_path,'/',subID,'/',targetE{1});
mkdir(outdir);


% emerge EEG.epoch and EEG.data when more than one datasets
EEGepoch        = struct.empty;
EEGdata         = single.empty(62,frame,0);

for i  = 1: length(set_list)
    EEG_tmppath   = strcat(set_list(i).folder,'/',set_list(i).name);
    EEG_tmp       = pop_loadset(EEG_tmppath);
    
    EEGdata        = cat(3,EEGdata,EEG_tmp.data);
    EEGepoch       = [EEGepoch,EEG_tmp.modepoch];
    
end

% get targetE avergared ERP
EEGtype = {EEGepoch.eventtype};
Stim = strcmp(EEGtype, targetE{1});
erp_tmp    = EEGdata(:,:,Stim);
erp_avg      = squeeze(nanmean(erp_tmp,3));
 
% get averaged ERP in erptopo way, and save a fig
cd (outdir)
if ploterptop == 1;
    figure,plottopo(erp_avg,EEG_tmp.chanlocs,frame,[EEG_tmp.times(1) EEG_tmp.times(end) -4 4],'',0,[0.05 0.08],{'k'},1);
    savefig('erp_topo.fig');
    % topography video
    MinERP = min(min(erp_avg))*1.2;
    MaxERP = max(max(erp_avg))*1.2;
    PlotMinMaxOrg = max(abs([MinERP,MaxERP]));
    video_name = strcat('topography_erp',targetE{1},'.avi');
    v          = VideoWriter(video_name); % name the video name
    open(v);
    % For all defined time points
    figure;
    for ii = 1:size(erp_avg,2)
        topoplot(erp_avg(:,ii),EEG_tmp.chanlocs,'headrad',0.55,'plotchans',1:62,'maplimits',[-PlotMinMaxOrg,PlotMinMaxOrg],'electrodes','on','numcontour',0);
        time_ind = ii-200
        title([num2str(time_ind),' ms'])
        colorbar


        frame = getframe(gcf);
        writeVideo(v,frame);
        hold off;
    end
    close(v);

end
% get ROI elec    
[elecs]      =  constrainelectrode(EEG_tmp.chanlocs,ROI);
close all
% get maxchann 
[maxchann]   = getmaxchan(erp_avg,EEG_tmp.times,elecs,timewindow);
erp_maxchann = squeeze(erp_tmp(maxchann(1),:,:));
% erp_minchann = squeeze(erp_tmp(minchann(end),:,:));
% save results
save('erpavg.mat','erp_avg','maxchann','erp_maxchann','elecs');
close all;
end

