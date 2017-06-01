function showModelComparison2D
%SHOWMODELCOMPARISON2D shows the AIC for all combinations of factors and rules for exp 9

factors = {'Base','G','D','GD','O','GO','DO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV'};
rules = {'Opt','Sum','Max','Min','Var','Sign','Max2','Max12','Max13','Max23','Max123','SumErf','SumErf1','SumErf2','SumErf3','SumErf12','SumErf13','SumErf23','SumX1','SumX2','SumX3','SumX12','SumX13','SumX23','SumX123'};

aicMat = zeros(length(factors),length(rules));




