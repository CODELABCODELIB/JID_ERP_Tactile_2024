function [chann]=selectelectrode(EEGdata,times,Orignalchanlocs,Stim, side);
% constrainelectrode
% elecs   = constrainelectrode(Orignalchanlocs,side); %
% [6,7,8,35,36,37,38,40,41,42,43];
[elecs] = constrainelectrode(Orignalchanlocs,side);
% 
indx0   = find(times==0);
erp     = EEGdata(:,indx0+25:indx0+75, Stim);
erp_avg = squeeze(mean(erp(:,:,:),3));

%laplacian_erp = laplacian_perrinX(erp_avg, [INEEG.chanlocs.X],[INEEG.chanlocs.Y],[INEEG.chanlocs.Z]);
    % Calculate the median over the whole preparation ERP signal for every electrode

    %[~,idx] = sort(median(laplacian_erp(elecs,:),2), 'descend');
[~,idx] = sort(max(erp_avg(elecs,:),[],2), 'descend');

    %[~,idx] = sort(median(laplacian_erp(elecs,:,:),3), 'descend');

chann = elecs(idx(1));
end