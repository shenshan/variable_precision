% this script inserts suboptimal models

% factors = {'','N','G','GN','O','NO','GO','GNO','VP','GVP','NVP','GNVP','OVP','GOVP','NOVP','GNOVP'};
% rules = {'Sum','Min','Max','Var'};
factors = {'Base','D','G','GD','O','DO','GO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV'};
rules = {'Min'};
% rules = {'SumErf3','SumErf12','SumErf13','SumErf23'};

key.exp_id = 7;
key.model_type = 'sub';

for ii = 1:length(factors)
    for jj = 1:length(rules)
        key.model_name = [factors{ii} rules{jj}];
        key.factor_code = factors{ii};
        key.npars = length(factors{ii}) + 1;
        insert(varprecision.Model, key);
    end
end
