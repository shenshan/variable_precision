% this script inserts suboptimal models

% factors = {'','N','G','GN','O','NO','GO','GNO','VP','GVP','NVP','GNVP','OVP','GOVP','NOVP','GNOVP'};
% rules = {'Sum','Min','Max','Var'};
factors = {'','G','O','GO','VP','GVP','OVP','GOVP'};
rules = {'Sign'};

key.exp_id = 9;
key.model_type = 'sub';

for ii = 1:length(factors)
    for jj = 1:length(rules)
        key.model_name = [factors{ii} rules{jj}];
        key.npars = length(factors{ii}) + 1;
        insert(varprecision.Model, key);
    end
end
