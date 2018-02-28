
subjs = fetch(varprecision.Subject & 'subj_type="real"');
models = fetch(varprecision.Model & 'model_name not in ("XP","XPG","XPVP","XPVPG")' & 'rule="Opt"' & 'prior_type = "Gaussian"');
exp_ids = [1,8,2:5,9,10,6,7,11];
dir_name = '~/Dropbox/VR/Estimated_parameters/';

for ii = 1:length(exp_ids)
    keys = fetch(varprecision.FitParsEviBpsBestAvg & ['exp_id =' num2str(exp_ids(ii))] & models);
    for ikey = keys'
        pars = fetch(varprecision.FitParsEviBpsBestAvg & ikey, '*');
        subj_initial = pars.subj_initial;
        exp_id = ii;
        model_name = varprecision.utils.decell(varprecision.utils.mapModelName(pars.model_name));
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
end

