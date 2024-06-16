function [intk, intk_1] = getintervaldynamics(EEG, targetE, relativeE)
% [intk, intk_1] = getintevaldynamics(EEG, targetE, relativeE)
% Estimates the next interval dynamics of events based on epoched EEG data
% Input
% TargetE> The Event in focus. For instance {'S  32'}
% relateivE> The Events based on which the intervals will be estimated can
% be the same as TargetE or other events such as {'S  32', 'S  33'} the OR
% operator is used then
% Output
% intK, 1 x N , where N is the number of trials.
% intK_1 (k-1), 1 x N , where N is the number of trials.
%
% Arko Ghosh, Leiden University, 11/08/2023
% edited by Wenyu Wan, Leiden Univeristy, 17/08/2023, line 18-22

% Identify the bvknum of all targetE
% create EEG.modepoch that each epoch only have one event
%EEG       = selectepoch(EEG);
Epoch_idx = ismember({EEG.modepoch.eventtype}, targetE);

% Extract values to use from EEG.urevent
TargetIdx = ismember({EEG.urevent.type}, relativeE);
TargetBvknum = [EEG.urevent.bvmknum];
TargetLatency = [EEG.urevent.latency];

% Now go through each event in epoched data and gather the corresponding
% intevals. insert NaN for non-target events or if the intevals are not
% available
for i = 1:size(EEG.modepoch,2)
    if Epoch_idx(i) % is it a target of interest

        % find the index of bvknum in the Urevent
        [tmp_uridx] = find(TargetBvknum == EEG.modepoch(i).eventbvmknum);

        % Now find the previous intevals
        tmp_intervals = TargetLatency(tmp_uridx) - TargetLatency(TargetIdx(1:tmp_uridx-1));

        if length(tmp_intervals)>1
            intk(1,i) = tmp_intervals(end);
            intk_1(1,i) = tmp_intervals(end-1)-tmp_intervals(end); % interval to the previous relativeE
        elseif length(tmp_intervals) == 1
            intk(1,i) = tmp_intervals(end);
            intk_1(1,i) = NaN;
        else
            intk(1,i) = NaN;
            intk_1(1,i) = NaN;
        end

    else
        intk(1,i) = NaN;
        intk_1(1,i) = NaN;

    end

    clear tmp*
end

end

