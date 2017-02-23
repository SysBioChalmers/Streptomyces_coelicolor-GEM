%
%   FILE NAME:    iMK1208_errorCorrection
% 
%   DATE CREATED: 2016-10-20
% 
%   PROGRAMMER:   Hao Wang
%                 Department of Biology and Biological Engineering
%                 Chalmers University of Technology
% 
% 
%   PURPOSE: This script is to correct errors found in the original iMK1208 model.
%

% 1. Missing of Heme A metabolite id was spoted from the original SBML file
% in lines 4970, 29734 and 33640. These problems were fixed by replacing
% line 4970:
%	<species name="Heme A" compartment="c" hasOnlySubstanceUnits="false" boundaryCondition="false" constant="false">
% with the following line:
%	<species id="M_hemeA_c" name="Heme A" compartment="c" hasOnlySubstanceUnits="false" boundaryCondition="false" constant="false">
%
% line 29734:
% <speciesReference stoichiometry="1"/>
%	with the following line:
% <speciesReference species="M_hemeA_c" stoichiometry="1"/>		
%
% and line 33640:
% <speciesReference stoichiometry="0.002387"/>
%	with the following line:
% <speciesReference species="M_ctp_c" stoichiometry="0.13226"/>
%
%	This problem probably caused by the typo in the associated Excel file
% at row 660, where the metabolite name was wrongly put as 'hemeA_#1[c][',
% which was manually fixed to 'hemeA[c]', and then saved to a new file:
% 'HW_biot_201300539_sm_suppinfo2.xlsx'

% 2. In addition, remove the addtional space after 'SCO01439' in line 48113 as 
% <p>GENE_ASSOCIATION: SCO1439</p>
%	The similar problem that has one additional space unexpectedly found before
% '</p>' occurred 18 times in GENE_ASSOCIATION feature for s0001. However,
% the other 11 cases are alright (without the additional space). This problem
% was fixed by manually removing that space in lines: 48489, 48939, 49133,
%	49827, 49856, 51974, 52005, 53755, 53976, 54323, 59694, 60813, 61434, 61463,
% 62268, 62297, 62326, 63188. And then save with all above changes to a new
% file: 'HW_biot_201300539_sm_suppinfo2.xml'

% 3. Because the model iMK1208 was developed by COBRA, so firstly read it in
% with COBRA environment. Note that the xml file is in SBML2 format, and the
% latest COBRA does not compatibile with SBML2 format. A safe way is to
% use the GitHub repository version before the master branch was updated with
% 'aebrahim-patch-1' branch. This version can be downloaded from
% https://github.com/opencobra/cobratoolbox/tree/10f98a0ab834118c6dfb943970c38d68c7e1ae70
% and then apply this COBRA version to Matlab path until step 7. It has been
% verified that the latest COBRA did cause unexpected problmes, most likely
% due to the incompatibility between different SBML fomrats!! 

model=readCbModel('HW_biot_201300539_sm_suppinfo2.xml');

% 4. Check growth for the imported model if it works.

sol=optimizeCbModel(model,'max','one');
disp(sol.f);
%===output message===
%    0.0699
%    
%=====output end=====

% 5. Add the missing metabolite charge state and KEGG IDs to the model
% Firstly read in these information from the Excel file

[numericData, textData]=xlsread('HW_biot_201300539_sm_suppinfo2.xlsx','Sheet2');

% Map the order of metabolites in Excel to those in xml file
% Then map the data from 'indexes' to model.mets metabolite charge data

[~,indexes] = ismember(model.mets,textData(3:1438,1));
model.metCharge=numericData(indexes);

% 6. Update KEGG IDs to model starting from the 3rd row

indexes=indexes+2;
model.metKEGGID=textData(indexes,7);

% 7. Clean the environment and save the model

clear textData numericData indexes sol;
writeCbModel(model,'sbml','iMK1208_HW_corrected.xml');
writeCbModel(model,'text','iMK1208_HW_corrected.txt');

% 8. Now this corrected SBML format model can be successfully import and
% exprot both by the latest and that old version of COBRA without any
% error messages!!

model=readCbModel('iMK1208_HW_corrected.xml');
