clear all;clc;
targetE ={'S  4'};
data_path = '/data1/wanw1/study01/left/NNMF';

cd (strcat(data_path,'/',targetE{1}))
load('nnmf_all.mat');
addpath(genpath('/data1/wanw1/toolbox/TDpassivetouch'));


basis    = cat(2,stable_basis_all{:});    %meta-ERP; times*clusters
loadings = cat(1,stable_loadings_all{:}); %meta-JID; clusters* bins

basis_all_pps = basis;
%% choose optimal k
% elbow method
nClusters=7; % pick/set number of clusters your going to use
totSum=zeros(nClusters-1,1);  % preallocate the result
for k=3:nClusters
    [~,~,sumd]=kmeans(basis_all_pps', k);
    totSum(k)=sum(sumd);
end
figure;
tiledlayout(2,1)
nexttile
plot(totSum)
xlim([3,7])
title('Elbow method')
nexttile
evaluation = evalclusters(basis_all_pps',"kmeans","silhouette","KList",3:7);
plot(evaluation)
title('Silhouette method')
close all;
%% silhoutte method
n_rep = 1000;
optimal_ks = zeros(n_rep,1);
optimal_ys = zeros(n_rep,size(basis_all_pps,2));
for rep=1:n_rep
    evaluation = evalclusters(basis_all_pps',"kmeans","Silhouette","KList",3:7);
    optimal_ks(rep) = evaluation.OptimalK;
    optimal_ys(rep,:) = evaluation.OptimalY;
end

selected_k = mode(optimal_ks);
%% actually perform kmeans
cluster_res = {};
numreps = 1000;
ssqs = zeros(numreps,1);
for rep=1:numreps
    [cluster_res_tmp, C, sumd] = kmeans(basis_all_pps', selected_k);
    cluster_res{rep} = cluster_res_tmp;
    ssqs(rep) = sum(sumd);
end
[~,idx] = min(ssqs);
cluster_res = cluster_res{idx};

basis = basis';
%% plots
figure;
max_lim =2.5; 
%max_lim = max(max(nanmean(loadings,1)))*1.2;
for i = 1:selected_k
    subplot(1, selected_k, i)
    plot([1:1:300],basis(cluster_res(:,1)==i,:),'-','color',[.5 .5 .5],'linewidth',0.01);
    hold on;plot([1:1:300],mean(basis(cluster_res(:,1)==i,:),1),'-k','linewidth',1.5);
    ylim([0 1.05]);
    set(gca,'XTick',[0 100 200 300],'XTickLabel',[]);
    set(gca,'YTick',[0 100 200 300],'YTickLabel',[]);
    hold on;
    plot([1:1:75],1.05*ones(1,75),'color',[0 0.4470 0.7410],'linewidth',4);
    hold on;
    plot([75:1:150],1.05*ones(1,76),'color',[0.8500 0.3250 0.0980],'linewidth',4);
    hold on;
    plot([150:1:300],1.05*ones(1,151),'color',[0.9290 0.6940 0.1250],'linewidth',4);
    axis square;
    set(gca,'XColor','none','YColor','none');
    
    %set(gca,'fontsize',12,'XTickLabel',[],'YTickLabel',[]);
    
    %hold on; plot()
    %title(strcat('Meta-time#',string(i)));
    axis square 
end
saveas(gcf,strcat('kmeans_metatime_', targetE{1},'.tif'));

figure; 
for i = 1:selected_k
subplot(1, selected_k, i)
    loadings_tmp= nanmean(loadings(cluster_res(:,1)==i,:),1);
    loadings_reshape = reshape(loadings_tmp,5,5);
    imagesc2([0.4 4.5],[0.5 4.5],loadings_reshape,[0 max_lim]);
    set(gca,'Ydir','normal');
    %set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'},'fontsize',12,'FontWeight','bold');
%     set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'},'fontsize',12);
%     set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'},'fontsize',12);
    set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',[]);
    set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',[]);
    axis square
    colormap('parula')
    %'fontsize',12,'FontWeight','bold'
    %title(strcat('Meta-JID#',string(i)))
    %colorbar
    %axis square
end


save('K-means.mat','selected_k','basis','loadings','cluster_res');
saveas(gcf,strcat('kmeans_metaJID_', targetE{1},'.tif'));

figure; caxis([0 2.5]);colorbar;
saveas(gcf,strcat('Kmeans_colorbar_',targetE{1},'.tif'));
