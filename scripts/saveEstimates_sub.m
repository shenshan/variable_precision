
subjs = fetch(varprecision.Subject & 'subj_type="real"');
models = fetch(varprecision.Model & 'model_name not in ("XP","XPG","XPVP","XPVPG")' & 'rule="Opt"' & 'prior_type = "Flat"');
dir_name = '~/Dropbox/VR/Estimated_parameters/';


keys = fetch(varprecision.FitParsEviBpsBestAvg & 'exp_id=4' & models);
for ikey = keys'
    pars = fetch(varprecision.FitParsEviBpsBestAvg & ikey, '*');
    subj_initial = pars.subj_initial;
    exp_id = 5;
    [factor_code, prior_type] = fetch1(varprecision.Model & ikey,'factor_code','prior_type');
    switch factor_code
        case 'DO'
            factor_code = 'OD';
        case 'GOD'
            factor_code = 'GOD';
        case 'DOV'
            factor_code = 'ODV';
        case 'GDOV'
            factor_code = 'GODV';
    end
    
    model_name = [factor_code prior_type];
    prior = pars.p_right_hat;
    J = pars.lambda_hat;
    tau = pars.theta_hat;
    beta = pars.beta_hat;
    lambda = pars.guess_hat;
    sigma_d = pars.sigma_dn_hat;

    exp_number = sprintf('Exp%02d_',exp_id);
    file_name = [exp_number subj_initial '_' model_name];

    if ~exist([dir_name file_name],'file')
        save([dir_name file_name],'prior','J','lambda','beta','sigma_d','tau');
    end

end


