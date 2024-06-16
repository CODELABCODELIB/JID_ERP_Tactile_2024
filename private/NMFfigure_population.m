function NMFfigure_population(stable_basis,stable_loading,k,targetE)
figure;
max_lim = 4;%max(max(stable_loading))*1.2;
min_lim = 0;
for i = 1: k
%load('/data1/wanw1/ANLpassive2/nmf/z/S2/nnmf_population.mat')
% NMF figures;
subplot(1,k,i)
plot([1:1:300],smooth(stable_basis(:,i)),'-k','linewidth',1.5)
ylim([0 1.05]);
%set(gca,'XTickLabel',[],'YTickLabel',[])
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

%title(strcat('Meta-ERP#',string(i)))
end
saveas(gcf,strcat('nnmf_metatime_', targetE{1},'.tif'));

figure; 
for i = 1:k
subplot(1,k,i)
pattern1 = reshape(stable_loading(i,:),5,5);
imagesc2([0.5 4.5],[0.5 4.5],pattern1,[min_lim max_lim]);
set(gca,'Ydir','normal');
set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',[]);
set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',[]);
% set(gca, 'YAxisLocation', 'left');
%xlabel('K[s]');
%ylabel('K-1[s]');
%colorbar;
axis square
colormap('parula')
%title(strcat('Meta-JID#',string(i)))
%colorbar

end
saveas(gcf,strcat('nnmf_metajid_', targetE{1},'.tif'));

end
% subplot(2,3,2)
% plot([1:1:300],smooth(stable_basis(:,2)),'-k')
% ylim([0 1]);
% axis square;
% title('Meta-ERP#2');
% 
% subplot(2,3,5)
% pattern2 = reshape(stable_loading(2,:),5,5);
% imagesc2([0.5 4.5],[0.5 4.5],pattern2,[-0.5 4]);
% set(gca,'Ydir','normal');
% set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
% set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});
% % set(gca, 'YAxisLocation', 'left');
% xlabel('ISI(K) [s]');
% ylabel('kISI(K-1) [s]');
% %colorbar;
% axis square
% title('Meta-JID-ERP#2');
% 
% subplot(2,3,3)
% plot([1:1:300],smooth(stable_basis(:,3)),'-k')
% ylim([0 1]);
% axis square;
% title('Meta-ERP#3');
% 
% subplot(2,3,6)
% pattern3 = reshape(stable_loading(3,:),5,5);
% imagesc2([0.5 4.5],[0.5 4.5],pattern3,[-0.5 4]);
% set(gca,'Ydir','normal');
% set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
% set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});
% % set(gca, 'YAxisLocation', 'left');
% xlabel('ISI(K) [s]');
% ylabel('kISI(K-1) [s]');
% %colorbar;
% axis square
% title('Meta-JID-ERP#3');
% colormap;
