% one sample t-test agnist 0
% load binerpavg_all and get averaged binerp across participant
clc;clear all;
data_path  = '/data1/wanw1/study01/binerpavg_all/sub_final';
targetE    = {'S  2'};
cd(strcat(data_path,'/',targetE{1}));
load('binerpavg_all.mat'); 
load('ANLonesamplettest.mat');
%remember to change the variable name below as well

% get averaged binerp value across participants
binsetup.N   = ones(5,5);
binsetup.times = [-200:1:299];

timerange   = [55 105 200]
%timerange   = [-50:50:250];

timerange1  = find(binsetup.times==timerange(1));
timerange2  = find(binsetup.times==timerange(2));
binerpavg   = squeeze(nanmean(binerpavg_all(:,:,:),1));
binerpavg_z = nanzscore(binerpavg,0,2);
erp_avg     = nanmean(erpavg_all,1);  
% 
% fig = figure
% set(fig, 'Units', 'inches');
% set(fig, 'Position', [0, 0, 8.27, 11.69]);

tiledlayout(length(timerange),2,'TileSpacing','compact')

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
      
        
        nexttile
        clims = [-3 3];
        imagesc([0.5 4.5],[0.5 4.5],binerp_zreshape,clims);
        set(gca,'Ydir','normal')
        set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',[]);
        set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',[]);
        %colorbar;
        colormap("turbo");
        axis square

end

saveas(gcf,strcat('exmple_JIDERP_', targetE{1},'.tif'));

%% correlation plot
time1 = nanzscore(binerpavg(255,:));
time2 = nanzscore(binerpavg(305,:));
time3 = nanzscore(binerpavg(400,:));
figure;
[rho] = corr(time1', time2','Type','Spearman','tail','right');
rho_3 = sprintf('%.3f',rho);
scatter(time1,time2,'filled');
hold on;
p = polyfit(time1,time2,1);
x_fit = linspace(-3,3,25);
y_fit = polyval(p,x_fit);
ylim([-3 3])
plot(x_fit,y_fit,'k-','LineWidth',2);
text(-0.2,2.5,['ρ=',num2str(rho_3),'(p>.05)'],'FontSize',18);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
xlabel('55ms')
ylabel('105ms')
saveas(gcf,strcat('exmple_scatter55_105', targetE{1},'.tif'));

figure
[rho,p1] = corr(time1', time3','Type','Spearman','tail','right');
rho_3 = sprintf('%.3f',rho);
scatter(time1,time3,'filled');
hold on;
p = polyfit(time1',time3',1);
x_fit = linspace(-3,3,25);
y_fit = polyval(p,x_fit);
ylim([-3 3])
plot(x_fit,y_fit,'r-','LineWidth',2);
text(-0.2,2.5,['ρ=',num2str(rho_3),'(p<.05)'],'FontSize',18);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
xlabel('55ms')
ylabel('200ms')
saveas(gcf,strcat('exmple_scatter55_200', targetE{1},'.tif'));

