function getpopolationvideo(binerpavg_all,erpmax_all)
% mean across subs
binerp_new  = squeeze(trimmean(binerpavg_all(:,:,:),20,1));
erpamax_new = mean(erpmax_all(:,:),1)';

binsetup.N   = ones(5,5);
binsetup.times = [-200:1:299];
timerange   = [-200 299];
timerange1  = find(binsetup.times==timerange(1));
timerange2  = find(binsetup.times==timerange(2));

% video
video_name = strcat('JIDERP_final.avi')
v = VideoWriter(video_name);
open(v);

figure;
for timepoint      = timerange1: timerange2
    binerp_tmp     = binerp_new(timepoint,:);
    binerp_tmpz    = nanzscore(binerp_tmp);
    binerp_reshape = reshape(binerp_tmp,size(binsetup.N,1),size(binsetup.N,2));
    binerp_zreshape = reshape(binerp_tmpz,size(binsetup.N,1),size(binsetup.N,2));
    
%h1 = axes;
subplot(1,3,2)

clims = [-3 3];
imagesc([0.5 4.5],[0.5 4.5],binerp_reshape,clims);
set(gca,'Ydir','normal')
set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});

% set(gca, 'YAxisLocation', 'left');
xlabel('k [s]');
ylabel('k-1 [s]');
title( 'raw(voltage)');
colorbar;
colormap("turbo");
axis square

subplot(1,3,3)

clims = [-3 3];

imagesc([0.5 4.5],[0.5 4.5],binerp_zreshape,clims);
set(gca,'Ydir','normal')

set(gca,'XTick',[0 1 2 3 4 5],'XTickLabel',{'0','0.5','1','2','4','8'});
set(gca,'YTick',[0 1 2 3 4 5],'YTickLabel',{'0','0.5','1','2','4','8'});
% set(gca, 'YAxisLocation', 'left');
xlabel('k [s]');
ylabel('k-1 [s]');
title('z(voltage)');
colorbar;
colormap("turbo");
axis square

subplot(1,3,1)
plot(binsetup.times,mean(erpamax_new,2), 'k');
hold on
scatter(binsetup.times(timepoint),mean(erpamax_new(timepoint,:),2), 'or', 'filled');
shg; 
axis square

sgtitle([num2str(binsetup.times(timepoint)) 'ms'])

frame = getframe(gcf);
writeVideo(v,frame);
hold off; 
%close all; 

%pause(0.01); % pause for 0.01 s
end

close(v);
end