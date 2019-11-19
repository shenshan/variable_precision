%{
# models considered
-> varprecision.Experiment
model_name      : varchar(50)            # model names
---
notes=null                  : varchar(256)                  # notes for this model
npars                       : tinyint                       # number of parameters
model_type="opt"            : enum('opt','sub','Simple','Max','SumErf','SumX') # optimal or suboptimal model
factor_code="Unknown"       : enum('Unknown','Base','G','D','GD','O','GO','DO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV') # combination of factors
rule="Opt"                  : enum('Opt','Sum','Max','Min','Var','Sign','Max2','Max12','Max13','Max23','Max123','SumErf','SumErf1','SumErf2','SumErf3','SumErf12','SumErf13','SumErf23','SumX1','SumX2','SumX3','SumX12','SumX13','SumX23','SumX123') # decision rules
prior_type="Gaussian"       : enum('Gaussian','Flat')       # flat prior or Gaussian prior
%}

classdef Model < dj.Manual
end