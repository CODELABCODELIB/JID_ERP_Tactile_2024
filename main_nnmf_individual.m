function main_nnmf_individual(data_path,out_path,targetE,method)

% main nnmf spams

%% get non-negative value
% shape electrodes x trials x time x participant(s)
% method1 = z(real);
% method2 = z(real)*sign;
% method3 = z(abs(real));
%clc;clear all;
%load('/data1/wanw1/ANLpassive3/binerpavg_all/S  2/binerpavg_final.mat','binerpavg_all','erpavg_all');
addpath(genpath('/home/wanw1/toolbox/NNMF_spams'))

path_tmp = strcat(data_path,'/',targetE{1});
cd(path_tmp);
load('binerpavg_all.mat','binerpavg_all','erpavg_all');

 % perform nnmf multiple times
    best_k_overall=2;
    for sub = 1:size(binerpavg_all,1)
    binerpavg = binerpavg_all(sub,:,:)
%% remove negativity of eeg data
%% method1-z(real)
if method ==1;
binerpavg         = squeeze(binerpavg);
binerpavg_z       = nanzscore(binerpavg(201:end,:),[],2);
binerpavg_tmp      = binerpavg_z - min(binerpavg_z,[],2);

%% method2-z(real)*sign
elseif method ==2
erp               = nanmean(erpavg_all,1);
erp               = erp(:,201:end);
idx               = ones(300,25);
idx(find(erp<0),:)  = -1;

binerpavg         = squeeze(binerpavg);
binerpavg_z       = nanzscore(binerpavg(201:end,:),[],2);
binerpavg_new     = binerpavg_z.*idx;
binerpavg_tmp      = binerpavg_new - min(binerpavg_new,[],2);
elseif method ==3
%% method3-z(abs(real))
binerpavg         = squeeze(binerpavg);
binerpavg         = abs(binerpavg);
binerpavg_z       = nanzscore(binerpavg(201:end,:),[],2);
binerpavg_tmp     = binerpavg_z - min(binerpavg_z,[],2);

end


%% NNMF
TP_jid              = binerpavg_tmp;
%TP_jid(isnan(TP_jid)) = 0;

% need to remove nan and readd nan
idx_tmp                   = 1:1:size(TP_jid,2);
TP_jid_idx                = find(isnan(TP_jid(1,:)));
TP_jid(:,TP_jid_idx)      = [];
idx                       = setdiff(idx_tmp,TP_jid_idx);

   for rep = 1:100
        [W, H] = perform_nnmf(TP_jid, best_k_overall);
        basis_all{rep,1} = W;
        loadings_all{rep,1} = H;
        
    end
[stable_basis, stable_loading] = stable_nnmf(basis_all,loadings_all, 1);
stable_loading = full(stable_loading);
stable_loading_new = nan(best_k_overall,25);
stable_loading_new(:,idx) = stable_loading;

stable_basis_all{sub,1}        = stable_basis;
stable_loadings_all{sub,1}     = full(stable_loading_new);

outdir         = strcat(out_path,'/',targetE{1});
mkdir(outdir);
cd (outdir)

save('nnmf_all.mat','stable_basis_all','stable_loadings_all')
    end

end
