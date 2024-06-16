function main_nnmf(data_path,out_path,targetE,method)

% main nnmf spams
% inputs
% data_path
% out_path
% targetE
% method
    % method1 = z(real);
    % method2 = z(real)*sign;
    % method3 = z(abs(real));
%% get non-negative value
% shape electrodes x trials x time x participant(s)

%clc;clear all;

addpath(genpath('/home/wanw1/toolbox/NNMF_spams'))
addpath(genpath('/home/wanw1/toolbox/TDpassivetouch'))

path_tmp = strcat(data_path,'/',targetE{1});
cd(path_tmp);
load('binerpavg_all.mat','binerpavg_all','erpavg_all');


%% remove negativity of eeg data
%% method1-z(real)
if method ==1;
binerpavg         = squeeze(nanmean(binerpavg_all,1));
binerpavg_z       = nanzscore(binerpavg(201:end,:),[],2);
binerpavg_tmp      = binerpavg_z - min(binerpavg_z,[],2);

%% method2-z(real)*sign
elseif method ==2
erp               = nanmean(erpavg_all,1);
erp               = erp(:,201:end);
idx               = ones(300,25);
idx(find(erp<0),:)  = -1;

binerpavg         = squeeze(nanmean(binerpavg_all,1));
binerpavg_z       = nanzscore(binerpavg(201:end,:),[],2);
binerpavg_new     = binerpavg_z.*idx;
binerpavg_tmp      = binerpavg_new - min(binerpavg_new,[],2);
elseif method ==3
%% method3-z(abs(real))
binerpavg         = squeeze(nanmean(binerpavg_all,1));
binerpavg         = abs(binerpavg);
binerpavg_z       = nanzscore(binerpavg(201:end,:),[],2);
binerpavg_tmp     = binerpavg_z - min(binerpavg_z,[],2);

end


%% NNMF
TP_jid             = binerpavg_tmp;

options.repetitions     = 10
basis_all               = {};
loadings_all            = {};
    [~, ~, ~, test_err] = nnmf_cv(TP_jid, 'repetitions',options.repetitions);
    [best_k_overall]    = choose_best_k({test_err}, 1);
    % perform nnmf multiple times
    for rep = 1:100
        [W, H] = perform_nnmf(TP_jid, best_k_overall);
        basis_all{rep,1} = W;
        loadings_all{rep,1} = H;
    end
    [stable_basis, stable_loading] = stable_nnmf(basis_all,loadings_all, 1);
    stable_loading = full(stable_loading);
    
outdir         = strcat(out_path,'/',targetE{1});
mkdir(outdir);
cd (outdir)

 %% ploting
 NMFfigure_population(stable_basis,stable_loading,best_k_overall,targetE);
 saveas(gcf,strcat('nnmf_', targetE{1},'.tif'));
 save ('nnmf.mat','stable_basis','stable_loading', 'best_k_overall');
end