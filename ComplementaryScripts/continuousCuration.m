% File name:        ContinuousCuration.m
%
% Purpose:          Continuous manual curation of Sco4, starting from Sco4
%                   release candidate 1 (4.0.0-rc.1) Each new section
%                   (indicated with %%) is when a new commit is made.
%
% Last modified:    2018-03-19 Eduard Kerkhoven
%

%% Load Sco4 release candidate 1
load('ModelFiles\mat\Sco4.mat')

%% fix: correct Matlab structuRemove
% Remove unnecessary field, geneShortNames is for names like 'Hxk1'.
model = rmfield(model, 'geneShortNames');
% Make geneFrom as long as genes
model.geneFrom(end+1:end+(length(model.genes) - length(model.geneFrom))) = {''};
% If no rxnReference given, use empty string instead of empty cell
model.rxnReferences(cellfun(@isempty,model.rxnReferences)) = {''};
% rxnConfidenceScores should be given as character array
model.rxnConfidenceScores=cellfun(@num2str,model.rxnConfidenceScores,'un',0);

%% fix-gene: remove s0001 pseudogene
% Remove 's0001' gene association (this represents spontaneous reactions,
% but it shouldn't have any gene associated, even artificial s0001 gene).
model.grRules = regexprep(model.grRules,' or s0001','');
model.grRules = regexprep(model.grRules,'s0001','');
model.geneMiriams(ismember(model.genes,'s0001')) = [];
model.geneFrom(ismember(model.genes,'s0001')) = [];
model.genes(ismember(model.genes,'s0001')) = [];

%% fix-rxns.prop: separate NADP-or-NAD containing reactions
% Some reactions have unspecified NAD or NADP usage (metabolite
% NAD-P-OR-NOP). Duplicate these reactions and specify either cofactor in
% each reaction to connect with the remaining network.
rxnIDs = find(model.S(getIndexes(model, 'NAD-P-OR-NOP_c', 'mets'),:));
for I = 1:length(rxnIDs)
    model = copyToComps(model, 'c', rxnIDs(I));
    oldEq = constructEquations(model, rxnIDs(I));
    NADP = regexprep(oldEq, 'NAD-P-OR-NOP', 'Nicotinamide adenine dinucleotide phosphate');
    NADP = regexprep(NADP, 'NADH-P-OR-NOP', 'Nicotinamide adenine dinucleotide phosphate - reduced');
    NAD = regexprep(oldEq, 'NAD-P-OR-NOP', 'Nicotinamide adenine dinucleotide');
    NAD = regexprep(NAD, 'NADH-P-OR-NOP', 'Nicotinamide adenine dinucleotide - reduced');
    model = changeRxns(model, model.rxns(rxnIDs(I)), NADP, 3);
    model.rxnNames(rxnIDs(I)) = strcat(model.rxnNames(rxnIDs(I)),' (NADPH)');
    model.rxns(rxnIDs(I)) = strcat(model.rxns(rxnIDs(I)),'_NADPH');
    model = changeRxns(model, model.rxns(end), NAD, 3);
    model.rxnNames(end) = strcat(model.rxnNames(end),' (NADH)');
    model.rxns(end) = regexprep(model.rxns(end),'_c$','_NADH');
end
model = removeMets(model,{'NADH-P-OR-NOP','NAD-P-OR-NOP'},true,false);

%% fix: correct Matlab structure rxnGeneMat
model.rxnGeneMat = getRxnGeneMat(model);

%% chore: use exportForGit function
exportForGit(model,'Sco4');

%% fix-rxns.prop: separate Acceptor containing reactions
% Same for acceptor / donor-h2
rxnIDs = find(model.S(getIndexes(model, 'Acceptor', 'metNames'),:));
for I = 1:length(rxnIDs)
    model = copyToComps(model, 'c', rxnIDs(I));
    oldEq = constructEquations(model, rxnIDs(I));
    NADP = regexprep(oldEq, 'Acceptor', 'Nicotinamide adenine dinucleotide phosphate');
    NADP = regexprep(NADP, 'Donor-H2', 'Nicotinamide adenine dinucleotide phosphate - reduced');
    NAD = regexprep(oldEq, 'Acceptor', 'Nicotinamide adenine dinucleotide');
    NAD = regexprep(NAD, 'Donor-H2', 'Nicotinamide adenine dinucleotide - reduced');
    model = changeRxns(model, model.rxns(rxnIDs(I)), NADP, 3);
    model.rxnNames(rxnIDs(I)) = strcat(model.rxnNames(rxnIDs(I)),' (NADPH)');
    model.rxns(rxnIDs(I)) = strcat(model.rxns(rxnIDs(I)),'_NADPH');
    model = changeRxns(model, model.rxns(end), NAD, 3);
    model.rxnNames(end) = strcat(model.rxnNames(end),' (NADH)');
    model.rxns(end) = regexprep(model.rxns(end),'_c$','_NADH');
end
model = removeMets(model,{'Acceptor','Donor-H2'},true,false);

%% fix-rxns: remove duplicate reactions
% Remove reactions where enzymes are included as metabolites. Duplicate
% reactions that are already present in combined-form.
model = removeReactions(model,{'RXN0-1134','RXN-7719','RXN0-1132',...
    '2.3.1.168-RXN','RXN0-1133','1.2.4.4-RXN'},true,true,true);

%% fix-rxns: remove unconnected out-of-scope reactions
% Unconnected tRNA modifying reactions, out of scope of metabolic model.
model = removeReactions(model,{'RXN-14570','6.3.5.6-RXN','6.3.5.7-RXN',...
    'RXN0-6274'},true,true,true);
% Remove protein-modifying reactions, out of scope of metabolic model.
model = removeReactions(model,{'RXN0-308'},true,true,true);

exportForGit(model,'model')

