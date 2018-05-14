# Streptomyces_coelicolor-GEM

- Brief Repository Description

This repository contains a genome-scale metabolic model **Sco4** for the antibiotic producer _Streptomyces coelicolor_ A3(2), a representative species of _Actinomycetales_.

- Abstract:

_Streptomyces coelicolor_ is a representative species of soil-dwelling, filamentous and gram-positive actinobacterium harbouring enriched secondary metabolite biosynthesis gene clusters. As a well-known pharmaceutical and bioactive compound producer, _S. coelicolor_ has been exploited for antibiotic and secondary metabolite production. Here, we present the updated model Sco4, which refers to the fourth major release of _S. coelicolor_ GEM and with increased coverage of both primary and secondary metabolism through using the [RAVEN](https://github.com/SysBioChalmers/RAVEN) Toolbox ver 2.0. The Sco4 model was expanded with 398 new metabolic reactions and 314 newly associated enzyme-coding genes, which encoded a variety of biosynthetic pathways for known secondary metabolites (e.g. 2-methylisoborneol, albaflavenone, desferrioxamine, geosmin, hopanoid and flaviolin dimer). The Sco4 model can be used as an upgraded platform for future systems biology research on _S. coelicolor_ and related species.

- Model KeyWords:

**GEM Category:** Species; **Utilisation:** Predictive simulation; **Field:** Metabolic-network reconstruction; **Type of Model:** Reconstruction and refinement; **Model Source:** [iMK1208](http://dx.doi.org/10.1002/biot.201300539); **Omic Source:** [Genomics](http://dx.doi.org/10.1038/417141a); **Taxonomy:** _Streptomyces coelicolor_; **Metabolic System:** General Metabolism; **Strain:** A3(2); **Condition:** Complex medium;

- Reference:
> Wang H _et al_. (2018) "RAVEN 2.0: a versatile platform for metabolic network reconstruction and a case study on Streptomyces coelicolor" bioRxiv doi:[https://doi.org/10.1101/321067}(10.1101/321067)

- Pubmed ID: TBA

- Last update: 2018-01-11

- The model contains:

| Taxonomy | Template Model | Reactions | Metabolites| Genes |
| ------------- |:-------------:|:-------------:|:-------------:|-----:|
| _Streptomyces coelicolor_ A3(2) | iMK1208 | 2304 | 1927 | 1522 |

This repository is administered by Hao Wang ([@SysBioChalmers](https://github.com/SysBioChalmers)), Division of Systems and Synthetic Biology, Department of Biology and Biological Engineering, Chalmers University of Technology



## Installation

### Required Software:

* A functional Matlab installation (MATLAB 7.3 or higher).
* The model was developed and also recommended to be used with the [RAVEN](https://github.com/SysBioChalmers/RAVEN) Toolbox ver 2.0 for MATLAB. 
* An up-to-date version from COBRA GitHub repository is strongly recommended.
* Add the directories to your Matlab path, instructions [here](https://se.mathworks.com/help/matlab/ref/addpath.html?requestedDomain=www.mathworks.com).

### Dependencies - Recommended Software:
* libSBML MATLAB API ([version 5.13.0](https://sourceforge.net/projects/sbml/files/libsbml/5.13.0/stable/MATLAB%20interface/)  is recommended).
* [Gurobi Optimizer for MATLAB](http://www.gurobi.com/registration/download-reg).


### Installation Instructions
* Clone the [master](https://github.com/SysBioChalmers/Streptomyces_coelicolor-GEM) branch from [SysBioChalmers GitHub](https://github.com/SysBioChalmers).
* Add the directory to your Matlab path, instructions [here](https://se.mathworks.com/help/matlab/ref/addpath.html?requestedDomain=www.mathworks.com).


## Contributors
* [Hao Wang](https://www.chalmers.se/en/staff/Pages/hao-wang.aspx), Chalmers University of Technology, Göteborg, Sweden

## License
The MIT License (MIT)

> Copyright (c) 2017 Systems and Synthetic Biology
>
> Chalmers University of Technology Gothenburg, Sweden
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
