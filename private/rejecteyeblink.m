function INEEG = rejecteyeblink(INEEG,eyeE)
% To remove eye blink artifact from EEG data
% --------------------------Usage-------------------------------------
% fomula: INEEG = ANL_rejecteyeblink(INEEG)
% Input(s):
%   - EEG struct from one participant
% Output(s):
%   - EEG struct after removing eye blink artifacts
% Requires:
%   - runICA
% Author: Wenyu Wan (万文雨）, Leiden Univeristy
% Date: 01/03/2023
try
idx = find(strcmp([INEEG.etc.skipchannels.labels], eyeE{1})|strcmp([INEEG.etc.skipchannels.labels], eyeE{2}) == true);  
catch
idx = find(strcmp({INEEG.chanlocs.labels}, eyeE{1})|strcmp({INEEG.chanlocs.labels}, eyeE{2}) == true);% are blink channels present
end


rej = [];
for j = 1:length(idx);
    try
    INEEG.icaquant{j} = icablinkmetrics(INEEG, 'ArtifactChannel', INEEG.etc.filter_1_70.skipchannels.data(idx(j),:), 'Alpha', 0.001, 'VisualizeData', 'False');
    catch
    INEEG.icaquant{j} = icablinkmetrics(INEEG, 'ArtifactChannel', INEEG.data(idx(j),:), 'Alpha', 0.001, 'VisualizeData', 'False');    
    end
    rej = [rej INEEG.icaquant{1,j}.identifiedcomponents];
end
Rej_Comp = unique([rej]);
% remove rej=0 elements, edited by Wenyu at 17/03/2024
Rej_Comp(find(Rej_Comp==0))=[];
INEEG = pop_subcomp(INEEG,Rej_Comp,0);

end