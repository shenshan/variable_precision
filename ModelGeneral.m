%{
varprecision.ModelGeneral (manual) # Models for all experiments
model_name: varchar(128)    # name of the model
-----
model_type="opt"            : enum('opt','sub')             # optimal or suboptimal model
factor_code="Unknown"       : enum('Unknown','Base','G','D','GD','O','GO','DO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV') # combination of factors
rule="Opt"                  : enum('Opt','Sum','Max','Min','Var','Sign','Max2','Max12','Max13','Max23','Max123','SumErf','SumErf1','SumErf2','SumErf3','SumErf12','SumErf13','SumErf23','SumX1','SumX2','SumX3','SumX12','SumX13','SumX23','SumX123') # decision rules
%}

classdef ModelGeneral < dj.Relvar
end