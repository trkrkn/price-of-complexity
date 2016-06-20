# Price of Complexity
Code and sampled data related to the study of the price of complexity in financial markets. This analysis estimates systemic risk in networks of financial institutions and shows how the increasing complexcity of the network of contract among institutions comes with the price of increasing inaccuracy in the estimation of systemic risk.

The code in this repository allows to reproduce the figures reported in the manuscript and to explore several further aspects (e.g. diffferent parameters setting, underlying network of contracts, effect of the introduction of derivative contracts).

Cite paper:
Battiston, S., Caldarelli, G., May, R., Roukny, T. and Stiglitz, J.E., 2015. 
The Price of Complexity in Financial Networks. 
Columbia Business School Research Paper, (15-49).

## *Errors on Contract Characteristics*

In this analysis, the systemic default probability is computed in a 2-banks market subject to the model introduced in (Battiston et al., 2015).  The level of accuracy of default probability is a function of parameter errors. 

The code allowing to run the study is written in MATLAB and is present in the sub-folder "01_matlab/". The file named "explorer.m" is the main script. Under specific parameter setting, it will produce 
- heat maps on the level of systemic default probability as a function of all pair of combination of parameters in the model
- the set of *uncertainty gaps*: for each parameter, a pair of curves with the same color represents the maximum and minimum value of the default probability as a function of the deviation on each parameter around a given point


## *Errors on the Structure of the Contract Network*