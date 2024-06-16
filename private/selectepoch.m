function INEEG = selectepoch (INEEG)
% To select event for each epoch when event>1 per epoch
% --------------------------Usage-------------------------------------
% fomula: INEEG = ANL_selectepoch (INEEG)

% Input(s):
%   - EEG struct from one participant

% Output(s):
%   - EEG struct with selected event per epoch

% Requires:
%   - after epoch


% Author: Wenyu Wan(万文雨), Leiden Univeristy
% Date: 17/04/2023
% edited at 27/08/2023, make it more flexible across different study
% datastes

Eventsize = arrayfun(@(x) size(x.event,2),INEEG.epoch);
Eventsize = Eventsize';

[row]=find(Eventsize>1);

INEEG.modepoch=INEEG.epoch;
fields = fieldnames(INEEG.epoch);

if ~isempty(row)

for p=1:length(Eventsize);
    %pp=row(p);   
    for pp=1: length(fields)
        field_tmp = fields{pp};
    [col_0] = find(~[INEEG.epoch(p).eventlatency{:}]);
    try
       INEEG.modepoch(p).(field_tmp) = INEEG.epoch(p).(field_tmp){col_0};
    catch
       INEEG.modepoch(p).(field_tmp) = INEEG.epoch(p).(field_tmp)(col_0);
    end

end
end

else
    
end 



end
