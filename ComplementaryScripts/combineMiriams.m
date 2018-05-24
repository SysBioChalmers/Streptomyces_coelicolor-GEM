function model = combineMiriams(model,i)
% combineMiriams
%   Combines rxnMiriams from one reaction to another.
%
%   model               model structure in RAVEN format
%   i                   2x1 double, where the first value is the index of
%                       the reaction that should remain, and the second
%                       value is the index of the reaction where rxnMiriams
%                       should be taken from
%
%   Rudimentary function, that should be expanded to also support other
%   fields, such as metMiriams, and ideally remove duplicates.
%
%   Usage: model=combineMiriams(model,i)
%
%   Eduard Kerkhoven, 2018-05-24
%
    f = fieldnames(model.rxnMiriams{i(2)});
    for j = 1:length(f)
        model.rxnMiriams{i(1)}.(f{j}) = [model.rxnMiriams{i(1)}.(f{j}); model.rxnMiriams{i(2)}.(f{j})];
    end
    jsonencode(model.rxnMiriams{i(1)})
end