% one sample t-test agnist 0
% load binerpavg_all and get averaged binerp across participant
clc;clear all;
data_path  = '/data1/wanw1/study01/left/binerpavg_all';
targetE    = {'S  4'};
cd(strcat(data_path,'/',targetE{1}));
load('binerpavg_all.mat'); %remember to change the variable name below as well
% get zscore 
binerpavg_allz = nanzscore(binerpavg_all,0,3);
% run one-sample ttest for a each bin at each timepoint
for t        = 1: size(binerpavg_allz,2)
    for bin  = 1: size(binerpavg_allz,3)
        binerp_tmp     = squeeze(binerpavg_allz(:,t,bin));
        [~,p1,~,stats] = ttest(binerp_tmp,0,'Alpha',0.05);
        p(t,bin)       = p1;
        tstat(t,bin)       = stats.tstat;
    end
end
% run FDR
[p_thre, p_masked] = fdr( p,0.05);
%[p_masked,p_thre] = Ffdr( p,0.05);
p_fdr = p;
p_fdr(~p_masked)   = nan;
tstat(~p_masked)   = nan;


save('ANLonesamplettest.mat','p','tstat','p_fdr');
% generate a  video
% video
video_name = strcat('JIDERP_final_',targetE{1},'.avi')
v = VideoWriter(video_name);
open(v);
% get averaged binerp value across participants
binsetup.N   = ones(5,5);
binsetup.times = [-200:1:299];
timerange   = [-200 299];
timerange1  = find(binsetup.times==timerange(1));
timerange2  = find(binsetup.times==timerange(2));
binerpavg   = squeeze(nanmean(binerpavg_all(:,:,:),1));
binerpavg_z = nanzscore(binerpavg,0,2);


figure;
for timepoint       = timerange1: timerange2
    binerp_tmp      = binerpavg(timepoint,:);
    binerp_tmpz     = binerpavg_z(timepoint,:);
    tstat_tmp       = tstat(timepoint,:);
    p_tmp           = p_fdr(timepoint,:);
    binerp_reshape  = reshape(binerp_tmp,size(binsetup.N,1),size(binsetup.N,2));
    binerp_zreshape = reshape(binerp_tmpz,size(binsetup.N,1),size(binsetup.N,2));
    tstat_reshape   = reshape(tstat_tmp,size(binsetup.N,1),size(binsetup.N,2));
    p_reshape       = reshape(p_tmp,size(binsetup.N,1),size(binsetup.N,2));
    
% raw JID-ERP
subplot(2,3,4) 

clims = [-3 3];
imagesc([0.5 4.5],[0.5 4.5],binerp_reshape,clims);
set(gca,'Ydir','normal')
set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});
% set(gca, 'YAxisLocation', 'left');
xlabel('K[s]');
ylabel('K-1[s]');
title( 'raw(voltage)');
colorbar;
colormap("turbo");
axis square

% z(JID-ERP)
subplot(2,3,5)

clims = [-3 3];
imagesc([0.5 4.5],[0.5 4.5],binerp_zreshape,clims);
set(gca,'Ydir','normal')
set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});
% set(gca, 'YAxisLocation', 'left');
xlabel('K[s]');
ylabel('K-1[s]');
title('z(voltage)');
colorbar;
colormap("turbo");
axis square


% tstat for z(JID-ERP)
subplot(2,3,6)

clims = [-10 10];
imagesc2([0.5 4.5],[0.5 4.5],tstat_reshape,clims);
set(gca,'Ydir','normal')

set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});
% set(gca, 'YAxisLocation', 'left');
xlabel('K[s]');
ylabel('k-1[s]');
title('t');
colorbar;
colormap("turbo");
axis square


% p(fdr) for z(JID-ERP)
% h1 = subplot(2,3,6)
% 
% clims = [0 0.05];
% imagesc2([0.5 4.5],[0.5 4.5],p_reshape,clims);
% set(gca,'Ydir','normal')
% set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
% set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});
% % set(gca, 'YAxisLocation', 'left');
% xlabel('k pre-interval [s]');
% ylabel('k-1 pre-interval [s]');
% title('p(fdr)');
% colorbar;
% colormap(h1,"autumn");
% axis square

% ERP amplitude
subplot(2,3,[1 2 3])
plot(binsetup.times,nanmean(erpavg_all,1), 'k');
hold on
scatter(binsetup.times(timepoint),nanmean(erpavg_all(:,timepoint),1), 'or', 'filled');
shg; 
% axis square

sgtitle([num2str(binsetup.times(timepoint)) 'ms'])

frame = getframe(gcf);
writeVideo(v,frame);
hold off; 
%close all; 

%pause(0.01); % pause for 0.01 s
end

close(v);


