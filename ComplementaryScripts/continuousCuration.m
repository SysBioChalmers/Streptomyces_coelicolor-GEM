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

%% fix-rxns: correct grRules
% Revert to iMK1208 provided grRules, while standardizing 'and'
% relationships.
model = changeGeneAssoc(model, 'OXDHCOAT', '(SCO5144 and SCO6701) or (SCO5144 and SCO6967) or (SCO5144 and SCO3079) or (SCO5144 and SCO6731)');
model = changeGeneAssoc(model, 'IBMi', '(SCO5415 and SCO4800) or (SCO5415 and SCO6833)');
model = changeGeneAssoc(model, 'AKGDH', '(SCO5281 and SCO2181 and SCO0884) or (SCO5281 and SCO2181 and SCO2180) or (SCO5281 and SCO2181 and SCO4919) or (SCO5281 and SCO7123 and SCO0884) or (SCO5281 and SCO7123 and SCO2180) or (SCO5281 and SCO7123 and SCO4919)');
model = changeGeneAssoc(model, 'AKGDH2', '(SCO4594 and SCO4595 and SCO0681) or (SCO6269 and SCO6270 and SCO0681)');
model = changeGeneAssoc(model, 'PAPSR', '(SCO6100 and SCO0885) or (SCO6100 and SCO3889) or (SCO6100 and SCO5419) or (SCO6100 and SCO5438)');
model = changeGeneAssoc(model, 'GLYCL', '(SCO5471 and SCO1378 and SCO5472 and SCO0884) or (SCO5471 and SCO1378 and SCO5472 and SCO2180) or (SCO5471 and SCO1378 and SCO5472 and SCO4919)');
model = changeGeneAssoc(model, '2MBCOATA', '(SCO1271 and SCO2389) or (SCO1271 and SCO0549) or (SCO1271 and SCO1267) or (SCO1271 and SCO1272) or (SCO2388 and SCO2389) or (SCO2388 and SCO0549) or (SCO2388 and SCO1267) or (SCO2388 and SCO1272) or (SCO6564 and SCO2389) or (SCO6564 and SCO0549) or (SCO6564 and SCO1267) or (SCO6564 and SCO1272)');
model = changeGeneAssoc(model, 'ACCOAC', '(SCO2445 and SCO2777) or (SCO2445 and SCO4921) or (SCO2445 and SCO6271) or (SCO5535 and SCO5536 and SCO2777) or (SCO5535 and SCO5536 and SCO4921) or (SCO5535 and SCO5536 and SCO6271)');
model = changeGeneAssoc(model, {'ACOATA', 'BCOATA', 'IBCOATA', 'IVCOATA', 'PCOATA'}, '(SCO1271 and SCO2389) or (SCO1271 and SCO0549) or (SCO1271 and SCO1267) or (SCO1271 and SCO1272) or (SCO2388 and SCO2389) or (SCO2388 and SCO0549) or (SCO2388 and SCO1267) or (SCO2388 and SCO1272) or (SCO6564 and SCO2389) or (SCO6564 and SCO0549) or (SCO6564 and SCO1267) or (SCO6564 and SCO1272)');
model = changeGeneAssoc(model, 'MCOATA', '(SCO2387 and SCO2389) or (SCO2387 and SCO0549) or (SCO2387 and SCO1267) or (SCO2387 and SCO1272)');
model = changeGeneAssoc(model, 'METSOXR1', '(SCO4956 and SCO0885) or (SCO4956 and SCO3889) or (SCO4956 and SCO5419) or (SCO4956 and SCO5438)');
model = changeGeneAssoc(model, 'METSOXR2', '(SCO6061 and SCO0885) or (SCO6061 and SCO3889) or (SCO6061 and SCO5419) or (SCO6061 and SCO5438)');
model = changeGeneAssoc(model, {'MPTG','MPTG2'}, '(SCO3847 and SCO2709) or (SCO3847 and SCO3894) or (SCO5301 and SCO2709) or (SCO5301 and SCO3894)');
model = changeGeneAssoc(model, {'RNDR1', 'RNDR2', 'RNDR3', 'RNDR4'},'(SCO5225 and SCO5226 and SCO0885) or (SCO5225 and SCO5226 and SCO3889) or (SCO5225 and SCO5226 and SCO5419) or (SCO5225 and SCO5226 and SCO5438) or (SCO5805 and SCO0885) or (SCO5805 and SCO3889) or (SCO5805 and SCO5419) or (SCO5805 and SCO5438)');
model = changeGeneAssoc(model, 'CYO2a', '(SCO2150 and SCO2149 and SCO7236) or (SCO2150 and SCO2149 and SCO2148) or (SCO2150 and SCO2149 and SCO7120)');
model = changeGeneAssoc(model, 'CYO2b', '(SCO1934 and SCO2156 and SCO2151 and SCO1930 and SCO7234) or (SCO1934 and SCO2156 and SCO2151 and SCO1930 and SCO2155)');
model = changeGeneAssoc(model, 'SUCD3', '(SCO4856 and SCO4855 and SCO4858 and SCO4857) or (SCO4856 and SCO5106 and SCO4858 and SCO4857) or (SCO5107 and SCO4855 and SCO4858 and SCO4857) or (SCO5107 and SCO5106 and SCO4858 and SCO4857) or (SCO7109 and SCO4855 and SCO4858 and SCO4857) or (SCO7109 and SCO5106 and SCO4858 and SCO4857)');
model = changeGeneAssoc(model, 'TRDR', '(SCO3890 and SCO0885) or (SCO3890 and SCO3889) or (SCO3890 and SCO5419) or (SCO3890 and SCO5438) or (SCO6834 and SCO0885) or (SCO6834 and SCO3889) or (SCO6834 and SCO5419) or (SCO6834 and SCO5438) or (SCO7298 and SCO0885) or (SCO7298 and SCO3889) or (SCO7298 and SCO5419) or (SCO7298 and SCO5438)');
model = changeGeneAssoc(model, 'PPCOAC', '(SCO2776 and SCO2777) or (SCO4380 and SCO4381) or (SCO4921 and SCO4925) or (SCO4921 and SCO4926) or (SCO6271 and SCO4925) or (SCO6271 and SCO4926)');
model = changeGeneAssoc(model, '2OXOADOX', '(SCO5281 and SCO2181 and SCO0884) or (SCO5281 and SCO2181 and SCO2180) or (SCO5281 and SCO2181 and SCO4919) or (SCO5281 and SCO7123 and SCO0884) or (SCO5281 and SCO7123 and SCO2180) or (SCO5281 and SCO7123 and SCO4919)');
model = changeGeneAssoc(model, 'THIORDXi', '(SCO2901 and SCO0885) or (SCO7353 and SCO0885) or (SCO2901 and SCO3889) or (SCO7353 and SCO3889) or (SCO2901 and SCO5419) or (SCO7353 and SCO5419) or (SCO2901 and SCO5438) or (SCO7353 and SCO5438) or SCO4444');
model = changeGeneAssoc(model, {'OIVD1', 'OIVD2', 'OIVD3'}, '(SCO3816 and SCO3817 and SCO3815 and SCO0884) or (SCO3816 and SCO3817 and SCO3815 and SCO2180) or (SCO3816 and SCO3817 and SCO3815 and SCO4919) or (SCO3816 and SCO3817 and SCO3829 and SCO0884) or (SCO3816 and SCO3817 and SCO3829 and SCO2180) or (SCO3816 and SCO3817 and SCO3829 and SCO4919) or (SCO3830 and SCO3831 and SCO3815 and SCO0884) or (SCO3830 and SCO3831 and SCO3815 and SCO2180) or (SCO3830 and SCO3831 and SCO3815 and SCO4919) or (SCO3830 and SCO3831 and SCO3829 and SCO0884) or (SCO3830 and SCO3831 and SCO3829 and SCO2180) or (SCO3830 and SCO3831 and SCO3829 and SCO4919)');

% Redefine, subunits were missing
model = changeGeneAssoc(model, 'PDH', '(SCO1269 and SCO1270 and SCO2183 and SCO0884 and SCO1268) or (SCO1269 and SCO1270 and SCO2183 and SCO0884 and SCO7123) or (SCO1269 and SCO1270 and SCO2183 and SCO0884 and SCO2181) or (SCO1269 and SCO1270 and SCO2183 and SCO2180 and SCO1268) or (SCO1269 and SCO1270 and SCO2183 and SCO2180 and SCO7123) or (SCO1269 and SCO1270 and SCO2183 and SCO2180 and SCO2181) or (SCO1269 and SCO1270 and SCO2183 and SCO4919 and SCO1268) or (SCO1269 and SCO1270 and SCO2183 and SCO4919 and SCO7123) or (SCO1269 and SCO1270 and SCO2183 and SCO4919 and SCO2181) or (SCO1269 and SCO1270 and SCO2371 and SCO0884 and SCO1268) or (SCO1269 and SCO1270 and SCO2371 and SCO0884 and SCO7123) or (SCO1269 and SCO1270 and SCO2371 and SCO0884 and SCO2181) or (SCO1269 and SCO1270 and SCO2371 and SCO2180 and SCO1268) or (SCO1269 and SCO1270 and SCO2371 and SCO2180 and SCO7123) or (SCO1269 and SCO1270 and SCO2371 and SCO2180 and SCO2181) or (SCO1269 and SCO1270 and SCO2371 and SCO4919 and SCO1268) or (SCO1269 and SCO1270 and SCO2371 and SCO4919 and SCO7123) or (SCO1269 and SCO1270 and SCO2371 and SCO4919 and SCO2181) or (SCO1269 and SCO1270 and SCO7124 and SCO0884 and SCO1268) or (SCO1269 and SCO1270 and SCO7124 and SCO0884 and SCO7123) or (SCO1269 and SCO1270 and SCO7124 and SCO0884 and SCO2181) or (SCO1269 and SCO1270 and SCO7124 and SCO2180 and SCO1268) or (SCO1269 and SCO1270 and SCO7124 and SCO2180 and SCO7123) or (SCO1269 and SCO1270 and SCO7124 and SCO2180 and SCO2181) or (SCO1269 and SCO1270 and SCO7124 and SCO4919 and SCO1268) or (SCO1269 and SCO1270 and SCO7124 and SCO4919 and SCO7123) or (SCO1269 and SCO1270 and SCO7124 and SCO4919 and SCO2181)');

% Not standardized, due to too many combinations
model = changeGeneAssoc(model, 'NADH17', 'SCO4564 and SCO4566 and SCO4568 and (SCO4562 or SCO4599) and (SCO4563 or SCO4600) and (SCO3392 or SCO4565) and (SCO4567 or SCO6560) and (SCO4569 or SCO4602) and (SCO4570 or SCO4603) and (SCO4571 or SCO4604) and (SCO4572 or SCO4605) and (SCO4573 or SCO4606 or SCO6954) and (SCO4574 or SCO4607) and (SCO4575 or SCO4608)');

exportForGit(model,'Sco4')

%% fix-rxns remove duplicate reactions
% GTHRDH and RXN-15856 are identical. SCO7508 annotated to RXN-15856 has
% more sequence similarity to glutamine amidotransferases, remove reaction.
model = removeReactions(model, 'RXN-15856', true, true, true);

% RXN-15586 and RXN-9930 are identical, remove the reaction with gene.
model = removeReactions(model, 'RXN-9930', true, true, true);

% G6PDH2 and GLU6PDEHYDROG-RXN are identical, keep iMK1208 reaction, while
% keeping rxnMiriams from MetaCyc reaction
i = getIndexes(model,{'GLU6PDEHYDROG-RXN','G6PDH2'},'rxns');
model.rxnMiriams(i(2)) = model.rxnMiriams(i(1));
model = removeReactions(model, 'GLU6PDEHYDROG-RXN', true, true, true);

% R03391 and 1.17.1.1-RXN_NADH are identical, second one was from reaction
% with unspecified NAD(P)H.
model = removeReactions(model, '1.17.1.1-RXN_NADH', true, true, true);

% RXN-13129 and 1.14.13.84-RXN_NADPH are identical, second one was from reaction
% with unspecified NAD(P)H.
model = removeReactions(model, '1.14.13.84-RXN_NADPH', true, true, true);

newCommit(model)
