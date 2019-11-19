%{
varprecision.AvgParsGodv (computed) # compute the mean and standard error of parameter fits of GODV model
-> varprecision.Experiment
-----
prior_mean: float   # mean of prior
prior_sem : float   # sem of prior
lambda_mean: blob  # mean of lambda
lambda_sem : blob  # sem of lambda
theta_mean : float  # mean of theta
theta_sem  : float  # sem of theta
beta_mean  : float  # mean of beta
beta_sem   : float  # sem of beta
guess_mean : float  # mean of guess
guess_sem  : float  # sem of guess
sigma_dn_mean : float  # mean of sigma dn
sigma_dn_sem  : float  # sem of sigma dn
%}

classdef AvgParsGodv < dj.Relvar & dj.AutoPopulate
    
	properties
        popRel = varprecision.Experiment & 'exp_id <12'
    end
    
    methods(Access = protected)

		function makeTuples(self, key)
            
            model = fetch(varprecision.Model & key & 'factor_code = "GDOV"' & 'rule = "Opt"' & 'prior_type = "Gaussian"');
            [prior_mat, lambda_mat, theta_mat, beta_mat, guess_mat, sigma_dn_mat] = fetchn(varprecision.FitParsEviBpsBestAvg & model,'p_right_hat','lambda_hat','theta_hat','beta_hat','guess_hat','sigma_dn_hat');
            
            key.prior_mean = mean(prior_mat);
            key.prior_sem = std(prior_mat)/sqrt(length(prior_mat));
            lambda_mat = varprecision.utils.decell(lambda_mat);
            lambda_mat = lambda_mat';
            key.lambda_mean = mean(lambda_mat);
            key.lambda_sem = std(lambda_mat)/sqrt(length(lambda_mat));
            key.theta_mean = mean(theta_mat);
            key.theta_sem = std(theta_mat)/sqrt(length(theta_mat));
            key.beta_mean = mean(beta_mat);
            key.beta_sem = std(beta_mat)/sqrt(length(beta_mat));
            key.guess_mean = mean(guess_mat);
            key.guess_sem = std(guess_mat)/sqrt(length(guess_mat));
            key.sigma_dn_mean = mean(sigma_dn_mat);
            key.sigma_dn_sem = std(sigma_dn_mat)/sqrt(length(sigma_dn_mat));
            
			self.insert(key)
		end
	end

end