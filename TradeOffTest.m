%{
varprecision.TradeOffTest (manual) # test trade off between factors/parameters
-> varprecision.Experiment
gene_model      : enum('CP','VP','OP')   # model to generate fake data set
test_model      : enum('CPG','VP','OP','OPVP')  # model to compute likelihood
test_id         : smallint               # test id
---
gene_pars                   : blob                          # parameters to generate fake data set, a vector of parameters
test_pars_ub                : blob                          # upper bound of test model parameters
test_pars_lb                : blob                          # lower bound of test model parameters
nsteps                      : blob                          # number of steps for each paramter
ntrials                     : smallint                      # number of simulation trials
%}

classdef TradeOffTest < dj.Relvar
end
