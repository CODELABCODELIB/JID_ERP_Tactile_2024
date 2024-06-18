function [all_ks] = choose_best_k(test_err_all, one_pp)
%% Select optimum number of ranks
%
% **Usage:**
%   - [all_ks] = select_best_k(test_err_all, pp)
%
% Input(s):
%    test_err_all cell = test error all participants
%           (shape : number of participants x 2) 
%   pp double = 0 : calculate k for all participants
%               Alternatively give the index of participant for which to calculate
%               the best rank
%
% Output(s):
%   all_ks = optimum number of rank(s)
%
% calculate best k per participant
% author: Kock Ruchella, Leiden University

if ~one_pp
    all_ks = [];
    for pp=1:length(test_err_all)
        x = cell2mat(test_err_all{pp});
        [~,k] = min(mean(x,1));
        all_ks = [all_ks k+1];
    end
% calculate best k for 1 select participant
else
    x = cell2mat(test_err_all{one_pp});
    [~,k] = min(mean(x,1));
    all_ks = k+1;
end
end
