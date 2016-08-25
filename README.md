# Price of Complexity
Code and synthetic data related to the study of the price of complexity in financial markets. This analysis estimates systemic risk in networks of financial institutions and shows how the increasing complexity of the network of contracts among institutions comes with the price of increasing inaccuracy in the estimation of systemic risk.

The code in this repository allows to reproduce the figures reported in the manuscript and to explore several further aspects (e.g. diffferent parameters setting, underlying network of contracts, effect of the introduction of derivative contracts).

Cite paper:
Battiston, S., Caldarelli, G., May, R., Roukny, T. and Stiglitz, J.E., 2016. 
*The Price of Complexity in Financial Networks.* 
Proceedings of the National Academy of Science.

Link to the paper: http://www.pnas.org/content/early/2016/08/22/1521573113

Here below referred to as (Battiston et al., 2015)

## *Errors on Contract Characteristics*

In this analysis, the systemic default probability is computed in a 2-banks market subject to the model introduced in (Battiston et al., 2015).  The level of accuracy of default probability is a function of parameter errors. 

The code allowing to run the study is written in MATLAB and is present in the sub-folder "01_matlab/". The file named "explorer.m" is the main script. After having defined the parameter setting, it will produce 
- heat maps on the level of systemic default probability as a function of all pairs of combination of parameters in the model
- the set of *uncertainty gaps*: for each parameter, a pair of curves with the same color represents the maximum and minimum value of the default probability as a function of the deviation on each parameter around a given point

## *Errors on the Structure of the Contract Network*

In this analysis, the systemic default probability is computed in a network context subject to the model introduced in (Battiston et al., 2015) and the second neighbor approximation. This allows to investigate how the systemic default probability depends on the complexity of the network of contracts. 

Given the heavy computation load due the large exploration space, the code allowing to run the study is set in an Object Oriented style, written in C++ together with a set of bash command to help running the analysis on a large-scale cluster infrastructure. The code is reported in the sub-folder "02_cplusplus/". The *Makefile* allows to directly compile the whole set of scripts and produces objects and the "run" application file to be used to obtain the results. A large series of network configuration data is also provided in the "network_files/" sub-folder, namely the one used to explore the effect of error in the underlying network strucutre of financial markets. A set of bash scripts can be used as benchmark to automatically produce large scale analysis. The main file ("main.cpp") exposes the set of parameters needed to run the analysis:

- number of agents	
- epsilon
- beta 
- delta
- mu
- sigma
- level of correlation
- recovery
- initial default probabilities
- cds notional (option)
- cds spread (option)
- error_threshold
- max_iteration
- number of shocks
- credit network source (file or generate)
- derivaties network source (option)

example of command: 
./run 2 5 5 5 0.1 0.2 0 1 0 0.5 0.5 10000 0.00001 0.5 network_test_3 network_test_3
