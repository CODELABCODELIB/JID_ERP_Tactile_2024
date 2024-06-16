function getbinerpvideo(subID,minN,timerange,binerp_avg,erp_avg,binsetup,method,targetE)
% To generate video of one condition for one particpant
% --------------------------Usage-------------------------------------
% fomula: 

% Input(s):
%   - subID: folder's name, like 'AT08'
%   - the minmum n number of bin
%   - timerange: the time range of EEG, like [-100 100]
%   - binerp: the bined erp. each cell for each bin. for each bin, erp data
%   was orgnized by [time*trails] matrix
%   - binsetup: more information in getbinerpnew() 
%   - method: 'nanmean' or 'nanmedian' or 'trimmean'


% Output(s):
%   - binserp_avg: [times* 1] the erp data of chann using the method
%   mentioned before
%   - Video: if video=1, then will store .avi video




% Author: Wenyu Wan(万文雨), Leiden Univeristy
% Date: 18/08/2023

timerange1 = find(binsetup.times==timerange(1));
timerange2 = find(binsetup.times==timerange(2));

% reject bins whose trials number <n
[N_small]  =  find(binsetup.n<minN);
for i = 1: length(N_small)
binerp_avg(:,N_small(i)) = nan(length(binsetup.times),1);
end

video_name = strcat('JIDERP_',subID,'_',targetE{1},'.avi')
v          = VideoWriter(video_name); % name the video name
open(v);


figure%('Position', [0 0 1024 576]);
for timepoint      = timerange1: timerange2
    binerp_tmp     = binerp_avg(timepoint,:);%
    binerp_tmpz    = nanzscore(binerp_tmp);
    binerp_reshape = reshape(binerp_tmp,size(binsetup.N,1),size(binsetup.N,2));
    binerp_reshape = single(binerp_reshape);
    binerp_zreshape = reshape(binerp_tmpz,size(binsetup.N,1),size(binsetup.N,2));
    binerp_zreshape = single(binerp_zreshape);
   
%     binerp_stdtmp     = binerp_std(timepoint,:);%
%     binerp_stdreshape = reshape(binerp_stdtmp,size(binsetup.N,1),size(binsetup.N,2));
%     binerp_stdreshape = single(binerp_stdreshape);
    
subplot(1,3,2)
imagesc([0.5 5.5],[0.5 5.5],binerp_reshape,[-3 3]);%*[0.5 4.5]
set(gca,'Ydir','normal')

set(gca,'XTick',[0 1 2 3 4 5 6],'XTickLabel',{'0','0.25','0.5','1','2','4','8'});%*remove 0.25
set(gca,'YTick',[0 1 2 3 4 5 6],'YTickLabel',{'0','0.25','0.5','1','2','4','8'});%*
% set(gca, 'YAxisLocation', 'left');
xlabel('k[s]');
ylabel('k-1[s]');
title('raw(voltage)');
%title([num2str(binsetup.times(timepoint)) 'ms'])
colormap("turbo");
colorbar;
axis square


subplot(1,3,3)
imagesc([0.5 5.5],[0.5 5.5],binerp_zreshape,[-3 3]);
set(gca,'Ydir','normal')

set(gca,'XTick',[0 1 2 3 4 5 6],'XTickLabel',{'0','0.25','0.5','1','2','4','8'});
set(gca,'YTick',[0 1 2 3 4 5 6],'YTickLabel',{'0','0.25','0.5','1','2','4','8'});
% set(gca, 'YAxisLocation', 'left');
xlabel('k[s]');
ylabel('k-1[s]');
title('z(voltage)');
%title([num2str(binsetup.times(timepoint)) 'ms'])
colorbar;
colormap("turbo");
axis square



subplot(1,3,1)
plot(binsetup.times,erp_avg, 'k');
hold on
scatter(binsetup.times(timepoint),erp_avg(timepoint,:), 'or', 'filled');
shg; 
axis square

%sgtitle('sub01 S1')
sgtitle([num2str(binsetup.times(timepoint)) 'ms']);


frame = getframe(gcf);
writeVideo(v,frame);
hold off; 
%close all; 

%pause(0.01); % pause for 0.01 s
end

close(v);


end
