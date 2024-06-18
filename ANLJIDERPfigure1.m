% one sample t-test agnist 0
% load binerpavg_all and get averaged binerp across participant
clc;clear all;
data_path  = '/data1/wanw1/study01/left/binerpavg_all';
targetE    = {'S  2'};
cd(strcat(data_path,'/',targetE{1}));
load('binerpavg_all.mat'); 
load('ANLonesamplettest.mat');
%remember to change the variable name below as well

% get averaged binerp value across participants
binsetup.N   = ones(5,5);
binsetup.times = [-200:1:299];

timerange   = [-15 15:40:290];

timerange1  = find(binsetup.times==timerange(1));
timerange2  = find(binsetup.times==timerange(2));
binerpavg   = squeeze(nanmean(binerpavg_all(:,:,:),1));
binerpavg_z = nanzscore(binerpavg,0,2);
erp_avg     = nanmean(erpavg_all,1);  

fig = figure
set(fig, 'Units', 'inches');
%set(fig, 'Position', [0, 0, 8.27,11.69]);
set(fig, 'Position', [0, 0, 7,11.69]);

tiledlayout(length(timerange),4,'TileSpacing','loose','Padding','loose')

for t       = 1:length(timerange)
    timepoint       = find(binsetup.times==timerange(t));
    binerp_tmp      = binerpavg(timepoint,:);
    binerp_tmpz     = binerpavg_z(timepoint,:);
    tstat_tmp       = tstat(timepoint,:);
    p_tmp           = p_fdr(timepoint,:);
    binerp_reshape  = reshape(binerp_tmp,size(binsetup.N,1),size(binsetup.N,2));
    binerp_zreshape = reshape(binerp_tmpz,size(binsetup.N,1),size(binsetup.N,2));
    tstat_reshape   = reshape(tstat_tmp,size(binsetup.N,1),size(binsetup.N,2));
    p_reshape       = reshape(p_tmp,size(binsetup.N,1),size(binsetup.N,2));
    
        nexttile
        % amplitude
        x_base = [-200 -50 -50 -200]
        y  = [-4  -4  4 4];
        fill(x_base,y,[0.5 0.5 0.5],'FaceAlpha',0.1,'LineStyle','none');
        hold on;
        plot(binsetup.times,nanmean(erpavg_all,1), 'r','linewidth',2);
        hold on;
        plot([0:1:75],3*ones(1,76),'color',[0 0.4470 0.7410],'linewidth',4);
        hold on;
        plot([75:1:150],3*ones(1,76),'color',[0.8500 0.3250 0.0980],'linewidth',4);
        hold on;
        plot([150:1:299],3*ones(1,150),'color',[0.9290 0.6940 0.1250],'linewidth',4);
        hold on
        plot(binsetup.times,erp_avg, 'k','linewidth',2);
        hold on
        scatter(binsetup.times(timepoint),erp_avg(:,timepoint), 'or', 'filled');
        ylim([-2 3])
        xline(0,'--k')
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        axis off
        % raw JID-ERP
        nexttile
        clims = [-3 3];
        imagesc([0.5 4.5],[0.5 4.5],binerp_reshape,clims);
        set(gca,'Ydir','normal')
        set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',[]);
        set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',[]);
        %colorbar;
        colormap("turbo");
        axis square
        
        nexttile
        clims = [-3 3];
        imagesc([0.5 4.5],[0.5 4.5],binerp_zreshape,clims);
        set(gca,'Ydir','normal')
        set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',[]);
        set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',[]);
        %colorbar;
        colormap("turbo");
        axis square
        
        nexttile
        clims = [-10 10];
        imagesc2([0.5 4.5],[0.5 4.5],tstat_reshape,clims);
        set(gca,'Ydir','normal')        
        set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',[]);
        set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',[]);
        %colorbar;
        colormap("turbo");
        axis square
        %colorbar

end

saveas(gcf,strcat('JIDERP_', targetE{1},'.tif'));

%% ERP amplitude
figure;
x_base = [-200 -50 -50 -200]
fill(x_base,y,[0.5 0.5 0.5],'FaceAlpha',0.1,'LineStyle','none');
hold on
plot(binsetup.times,erpavg_all, 'color',[0.5 0.5 0.5],'linewidth',1);
xline(0,'--k','linewidth',2);
axis off
ylim([-4 4]);
hold on; 
plot(binsetup.times,nanmean(erpavg_all,1), 'r','linewidth',2);
hold on;
plot([0:1:75],4*ones(1,76),'color',[0 0.4470 0.7410],'linewidth',4);
hold on;
plot([75:1:150],4*ones(1,76),'color',[0.8500 0.3250 0.0980],'linewidth',4);
hold on;
plot([150:1:299],4*ones(1,150),'color',[0.9290 0.6940 0.1250],'linewidth',4);

saveas(gcf,strcat('ERP_', targetE{1},'.tif'));

% ROI density
% figure; 
% load('Orignalchanlocs.mat');
% chans = unique(erp_maxchann);
% [counts, ~] = hist(erp_maxchann, chans);
% topoplot([],Orignalchanlocs,'plotchans',chans,'style','black','electrodes','on','emarker',{'o','r',15,1},'headrad',0.55,'plotrad',0.7);
% hold on
% topoplot([],Orignalchanlocs,'style','blank','electrodes','on','plotchans',1:62,'headrad',0.55,'plotrad',0.7);
% saveas(gcf,strcat('chans_', targetE{1},'.tif'));

% JID and fill with ERPs
tiledlayout(size(binsetup.N,1),size(binsetup.N,2),'TileSpacing','loose');
idx_tmp = binsetup.binmatrix(:,3);
idx_reshape = reshape(idx_tmp,size(binsetup.N,1),size(binsetup.N,2))
idx_reshape = idx_reshape';
idx         = reshape(flip(idx_reshape,2),[],1);
binerpavg   = squeeze(nanmean(binerpavg_all,1));
for i = 1:25
        
        nexttile
        plot([-200:1:299],binerpavg(:,idx(i)),'k');
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        ylim([-2 3])
        %xlim([-250:1:350])
        axis off
end  
saveas(gcf,strcat('binerp_', targetE{1},'.tif'));
