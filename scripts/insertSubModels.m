% this script inserts suboptimal models

% factors = {'','N','G','GN','O','NO','GO','GNO','VP','GVP','NVP','GNVP','OVP','GOVP','NOVP','GNOVP'};
% rules = {'Sum','Min','Max','Var'};
factors = {'','G','N','GN'};
rules = {'Mx010','Mx110','Mx101','Mx011','Mx111','SmX100','SmX010','SmX001','SmX110','SmX101','SmX011','SmX111','SmErf000','SmErf100','SmErf010','SmErf001','SmErf110','SmErf101','SmErf011'};

key.exp_id = 9;
key.model_type = 'sub';

for ii = 1:length(factors)
    for jj = 1:length(rules)
        key.model_name = [factors{ii} rules{jj}];
        key.npars = length(factors{ii}) + 1;
        insert(varprecision.Model, key);
    end
end
