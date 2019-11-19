var_models = {'VP','VPG','VPN','VPGN','OPVP','OPVPG','OPVPN','OPVPGN'};
non_var_models = {'CP','CPG','CPN','CPGN','OP','OPG','OPN','OPGN'};

aic_diff = zeros(1,8);
bic_diff = zeros(1,8);
for ii = 1:length(var_models)
    [aic_non_var(ii),bic_non_var(ii),llmax_non_var(ii)] = fetch1(varprecision.FitParsEviBpsBestAvg & 'exp_id=11' & ['model_name = "' non_var_models{ii} '"'] & 'subj_initial="MGL"','aic','bic','llmax');
    [aic_var(ii),bic_var(ii),llmax_var(ii)] = fetch1(varprecision.FitParsEviBpsBestAvg & 'exp_id=11' & ['model_name = "' var_models{ii} '"'] & 'subj_initial="MGL"','aic','bic','llmax');
end

min_val = 0;
aic_non_var = aic_non_var - min_val;
bic_non_var = bic_non_var - min_val;
aic_var = aic_var - min_val;
bic_var = bic_var - min_val;
aic_diff = aic_non_var-aic_var
bic_diff = bic_non_var-bic_var

fpp_aic = sum(exp(-aic_var))/(sum(exp(-aic_var))+sum(exp(-aic_non_var)))
fpp_bic = sum(exp(-bic_var))/(sum(exp(-bic_var))+sum(exp(-bic_non_var)))