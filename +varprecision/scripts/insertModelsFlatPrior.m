% this script inserts suboptimal models


factors = {'Base','D','G','GD','O','DO','GO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV'};
prior = {'Flat'};

key.exp_id = 4;
key.model_type = 'opt';

for ii = 1:length(factors)
    for jj = 1:length(prior)
        key.model_name = [factors{ii} prior{jj}];
        key.factor_code = factors{ii};
        key.npars = length(factors{ii}) + 2;
        key.rule = 'Opt';
        key.prior_type = 'Flat';
        insert(varprecision.Model, key);
    end
end
