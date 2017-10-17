% this script inserts suboptimal models

% factors = {'','N','G','GN','O','NO','GO','GNO','VP','GVP','NVP','GNVP','OVP','GOVP','NOVP','GNOVP'};
% rules = {'Sum','Min','Max','Var'};
factors = {'O','GO','NO','GNO','V','GV','NV','GNV','OV','GOV','GNOV'};
% rules = {'Max2','Max12','Max13','Max23','Max123'};
rules = {'SumErf'};

key.exp_id = 9;
key.model_type = 'sub';

for ii = 1:length(factors)
    for jj = 1:length(rules)
        key.model_name = [factors{ii} rules{jj}];
        key.factor_code = factors{ii};
        key.npars = length(factors{ii}) + 2;
        insert(varprecision.Model, key);
    end
end
