function [chann_max] = getmaxchan(erp_avg,times,elecs,timewindow)

indx0   = find(times==0);
erp_avg_tmp = squeeze(mean(erp_avg(:,indx0+timewindow(1):indx0+timewindow(2),:),3));

%laplacian_erp = laplacian_perrinX(erp_avg, [INEEG.chanlocs.X],[INEEG.chanlocs.Y],[INEEG.chanlocs.Z]);
    % Calculate the median over the whole preparation ERP signal for every electrode

    %[~,idx] = sort(median(laplacian_erp(elecs,:),2), 'descend');
[~,idx] = sort(max(erp_avg(elecs,:),[],2), 'descend');
    %[~,idx] = sort(median(laplacian_erp(elecs,:,:),3), 'descend');
%chann = elecs(idx(1));
chann_max = elecs(idx);
end