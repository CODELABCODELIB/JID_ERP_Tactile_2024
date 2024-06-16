function getcorrplot_population(data_path, targetE, type2)
% data_path: the path stored the binerpavg_all
% targetE: the condition you aimed to, it can be {'S  1'}, {'S  2'}, {'S  4'}
% type2: whether remove <0.5S bins or not; 1=remove, 0= do NOT remove;

data_path1 = strcat(data_path,'/',targetE{1});
cd(data_path1);
load('binerpavg_all.mat'); %remember to change the variable name below as well

if type2 ==1
% will be removed
indx_1 = find(binsetup.binmatrix(:,1)==1);
indx_2 = find(binsetup.binmatrix(:,2)==1);
indx = [indx_1;indx_2];
indx = unique(indx);
indx = indx';

binerpavg_all(:,:,indx) = [];
else
end

binerp_avg = squeeze(nanmean(binerpavg_all(:,:,:),1));

k = 0;
for t = 1:500

target = t;
for i = 1:500
idxnan = and(isnan(binerp_avg(target,:)), isnan(binerp_avg(i,:)));

[rho(i) pval(i)] = corr(nanzscore((binerp_avg(target,~idxnan)')), nanzscore((binerp_avg(i,~idxnan)')),'Type','Spearman','tail','right');

end
k = k+1;
corrzabs(k,:) = rho;
p(k,:)     = pval;

end

ii  = ones(size(corrzabs));
idx = triu(rot90(ii),25); % filtered upto 40hz, which means the signals of approx 25 ms
idx = logical(idx);
corrzabs(~idx)=nan;
p(~idx)=nan;

[p_thre, p_masked] = fdr( p,0.05);
p_fdr = p;
p_fdr(~p_masked)=nan;


figure;imagesc2([-200.5 299.5],[-200 299.5],corrzabs,[-1 1]);
set(gca,'Ydir','normal','yaxislocation','right');
set(gca,'XTickLabel',[])%{'0','0.5','1','2','4','8'});
set(gca,'YTickLabel',[]);
hold on;
plot([0:1:75],300*ones(1,76),'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot([75:1:150],300*ones(1,76),'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot([150:1:299],300*ones(1,150),'color',[0.9290 0.6940 0.1250],'linewidth',6);
hold on
plot(-200*ones(1,76),[0:1:75],'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot(-200*ones(1,76),[75:1:150],'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot(-200*ones(1,150),[150:1:299],'color',[0.9290 0.6940 0.1250],'linewidth',6);
set(gca, 'YColor', 'none');
axis square
hold on; xline(0,'--k','LineWidth',1);
hold on; yline(0,'--k','LineWidth',1);
set(gca,'XColor','none');
saveas(gcf,strcat('corrzfor', targetE{1},'.tif'));


figure;imagesc2([-200.5 299.5],[-200 299.5],p,[0 1]);
set(gca,'Ydir','normal','yaxislocation','right');
set(gca,'XTickLabel',[])%{'0','0.5','1','2','4','8'});
set(gca,'YTickLabel',[])
hold on;
plot([0:1:75],300*ones(1,76),'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot([75:1:150],300*ones(1,76),'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot([150:1:299],300*ones(1,150),'color',[0.9290 0.6940 0.1250],'linewidth',6);
hold on
plot(-200*ones(1,76),[0:1:75],'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot(-200*ones(1,76),[75:1:150],'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot(-200*ones(1,150),[150:1:299],'color',[0.9290 0.6940 0.1250],'linewidth',6);
set(gca, 'YColor', 'none');
colormap("summer")
axis square
hold on; xline(0,'--k','LineWidth',1);
hold on; yline(0,'--k','LineWidth',1);
set(gca,'XColor','none');
saveas(gcf,strcat('pzfor', targetE{1},'.tif'));

figure;imagesc2([-200.5 299.5],[-200 299.5],p_fdr,[0 1]);
set(gca,'Ydir','normal','yaxislocation','right');
set(gca,'XTickLabel',[])%{'0','0.5','1','2','4','8'});
set(gca,'YTickLabel',[])
hold on;
plot([0:1:75],300*ones(1,76),'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot([75:1:150],300*ones(1,76),'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot([150:1:299],300*ones(1,150),'color',[0.9290 0.6940 0.1250],'linewidth',6);
hold on
plot(-200*ones(1,76),[0:1:75],'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot(-200*ones(1,76),[75:1:150],'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot(-200*ones(1,150),[150:1:299],'color',[0.9290 0.6940 0.1250],'linewidth',6);
set(gca, 'YColor', 'none');
axis square
hold on; xline(0,'--k','LineWidth',1);
hold on; yline(0,'--k','LineWidth',1);
set(gca,'XColor','none');
colormap("summer")
saveas(gcf,strcat('pzfdrfor', targetE{1},'.tif'));


% example
figure;imagesc2([-200.5 299.5],[-200 299.5],p_stdfdr,[0 1]);
set(gca,'Ydir','normal','yaxislocation','right');
set(gca,'XTickLabel',[])%{'0','0.5','1','2','4','8'});
set(gca,'YTickLabel',[])
hold on;
plot([0:1:75],300*ones(1,76),'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot([75:1:150],300*ones(1,76),'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot([150:1:299],300*ones(1,150),'color',[0.9290 0.6940 0.1250],'linewidth',6);
hold on
plot(-200*ones(1,76),[0:1:75],'color',[0 0.4470 0.7410],'linewidth',6);
hold on;
plot(-200*ones(1,76),[75:1:150],'color',[0.8500 0.3250 0.0980],'linewidth',6);
hold on;
plot(-200*ones(1,150),[150:1:299],'color',[0.9290 0.6940 0.1250],'linewidth',6);
set(gca, 'YColor', 'none');
axis square
hold on; xline(0,'--k','LineWidth',1);
hold on; yline(0,'--k','LineWidth',1);
set(gca,'XColor','none');
colormap("white")
saveas(gcf,strcat('sketch_corr.tif'));


save ('corrresult.mat','corrzabs', 'p','p_fdr');
end
