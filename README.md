# Streptomyces_coelicolor-GEM

- Brief Repository Description

This repository contains a genome-scale metabolic model **Sco4** for the antibiotic producer _Streptomyces coelicolor_ A3(2), a representative species of _Actinomycetales_.

- Abstract:

_Streptomyces coelicolor_ is a representative species of soil-dwelling, filamentous and gram-positive actinobacterium harbouring enriched secondary metabolite biosynthesis gene clusters. As a well-known pharmaceutical and bioactive compound producer, _S. coelicolor_ has been exploited for antibiotic and secondary metabolite production. Here, we present the updated model Sco4, which refers to the fourth major release of _S. coelicolor_ GEM and with increased coverage of both primary and secondary metabolism through using the [RAVEN](https://github.com/SysBioChalmers/RAVEN) Toolbox ver 2.0. The Sco4 model was expanded with 398 new metabolic reactions and 314 newly associated enzyme-coding genes, which encoded a variety of biosynthetic pathways for known secondary metabolites (e.g. 2-methylisoborneol, albaflavenone, desferrioxamine, geosmin, hopanoid and flaviolin dimer). The Sco4 model can be used as an upgraded platform for future systems biology research on _S. coelicolor_ and related species.

- Model KeyWords:

**GEM Category:** Species; **Utilisation:** Predictive simulation; **Field:** Metabolic-network reconstruction; **Type of Model:** Reconstruction and refinement; **Model Source:** [iMK1208](http://dx.doi.org/10.1002/biot.201300539); **Omic Source:** [Genomics](http://dx.doi.org/10.1038/417141a); **Taxonomy:** _Streptomyces coelicolor_; **Metabolic System:** General Metabolism; **Strain:** A3(2); **Condition:** Complex medium;

- Reference:
> Wang H _et al_. (2018) "RAVEN 2.0: a versatile platform for metabolic network reconstruction and a case study on Streptomyces coelicolor" bioRxiv doi:[10.1101/321067](https://doi.org/10.1101/321067)

- Pubmed ID: TBA

- Last update: 2018-05-14

- The model contains:

| Taxonomy | Template Model | Reactions | Metabolites| Genes |
| ------------- |:-------------:|:-------------:|:-------------:|-----:|
| _Streptomyces coelicolor_ A3(2) | iMK1208 | 2322 | 1906 | 1506 |

This repository is administered by Hao Wang ([@SysBioChalmers](https://github.com/SysBioChalmers)), Division of Systems and Synthetic Biology, Department of Biology and Biological Engineering, Chalmers University of Technology

## Installation

### Recommended Software:
* A functional Matlab installation (MATLAB 7.3 or higher).
* [RAVEN Toolbox 2](https://github.com/SysBioChalmers/RAVEN) for MATLAB (required for contributing to development). 
* libSBML MATLAB API ([version 5.16.0](https://sourceforge.net/projects/sbml/files/libsbml/5.13.0/stable/MATLAB%20interface/)  is recommended).
* [Gurobi Optimizer for MATLAB](http://www.gurobi.com/registration/download-reg).
* For contributing to development: a [git wrapper](https://github.com/manur/MATLAB-git) added to the search path.

### Installation Instructions
* Clone the [master](https://github.com/SysBioChalmers/Streptomyces_coelicolor-GEM) branch from [SysBioChalmers GitHub](https://github.com/SysBioChalmers).
* Add the directory to your Matlab path, instructions [here](https://se.mathworks.com/help/matlab/ref/addpath.html?requestedDomain=www.mathworks.com).

### Contribute to development
1. Fork the repository to your own Github account
2. Create a new branch from [`devel`](https://github.com/SysBioChalmers/Streptomyces_coelicolor-GEM/tree/devel).
3. Make changes to the model
    + [RAVEN Toolbox 2](https://github.com/SysBioChalmers/RAVEN) for MATLAB is highly recommended for making changes
    + Before each commit, run in Matlab the `newCommit(model)` function from the `ComplementaryScripts` folder
    + Make a Pull Request to the `devel` folder, including changed `txt`, `yml` and `xml` files

## Contributors
* [Hao Wang](https://www.chalmers.se/en/staff/Pages/hao-wang.aspx) ([@Hao-Chalmers](https://github.com/Hao-Chalmers)), Chalmers University of Technology, Göteborg, Sweden
* [Eduard J. Kerkhoven](https://www.chalmers.se/en/staff/Pages/Eduard-Kerkhoven.aspx) ([@edkerk](https://github.com/edkerk)), Chalmers University of Technology, Göteborg, Sweden