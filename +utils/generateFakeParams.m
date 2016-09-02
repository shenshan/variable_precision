function pars = generateFakeParams(mode,varargin)
%GENERATEFAKEPARAMS generates a single set of parameters, for later on fake
%data generation
%   mode specifies the way to generate fake parameters, random or based on
%   real subject parameters
%   varargin should contain exp_id, model_name.

assert(ismember(mode,{'real','random'}),'Invalid mode input, please enter real or random.')
varargins1 = fetch(varprecision.FitParametersEvidence & varargin);
if strcmp(mode,'random')
    assert(~isempty(varargins1), 'Real fitting parameters does not exist.')
end
varargins2 = fetch(varprecision.ParameterSet & varargin);
assert(~isempty(varargins2),'No paramter set found. Please check the validity of the inputs.')
models = fetch(varprecision.Model & varargin,'*');
assert(length(models)==1,'Please make sure that only one experiment and model is included.')

pars_set = fetch(varprecision.ParameterSet & varargin, '*');
p_right_vec = pars_set.p_right;
lambda_vec = pars_set.lambda;
theta_vec = pars_set.theta;
guess_vec = pars_set.guess;

if strcmp(mode,'real')
    [p_right,lambda,theta,guess] = fetchn(varprecision.FitParametersEvidence & varargin, 'p_right_hat','lambda_hat','theta_hat','guess_hat');
    
    [p_right_mean,p_right_std] = varprecision.utils.getMeanStd(p_right,'std');
    if iscell(lambda)
        lambda = varprecision.utils.decell(lambda);
        [lambda_mean,lambda_std] = varprecision.utils.getMeanStd(lambda,'std',3);
    else
        [lambda_mean,lambda_std] = varprecision.utils.getMeanStd(lambda,'std');
    end
    pars.p_right = max(p_right_mean + p_right_std*randn, min(p_right_vec));
    pars.lambda = max(lambda_mean + lambda_std*randn, min(lambda_vec)); 
    
    if ismember(models.model_name,{'CPG','VPG','XPG'})
        [guess_mean,guess_std] = varprecision.utils.getMeanStd(guess);
        pars.guess = max(guess_mean + guess_std*randn, min(guess_vec));
    end
    
    if ismember(models.model_name,{'VP','VPG','XP','XPG'})
        [theta_mean,theta_std] = varprecision.utils.getMeanStd(theta);
        pars.theta = max(theta_mean + theta_std*randn, min(theta_vec));
    end    
else
    
    pars.p_right = min(p_right_vec) + rand*range(p_right_vec);
    
    exp = fetch(varprecision.Experiment & varargins2);
    if ismember(exp.exp_id,[3,5,7,10,11])
        setsize = fetch1(varprecision.Experiment & models,'setsize');
        pars.lambda = repmat(lambda_vec,1,length(setsize)) + rand*range(lambda_vec);
    else
        pars.lambda = min(lambda_vec) + rand*range(lambda_vec);
    end
    
    if ismember(models.model_name,{'CPG','VPG','XPG'})
        pars.guess = min(guess_vec) + rand*range(guess_vec);
    end
    
    if ismember(models.model_name,{'VP','VPG','XP','XPG'})
        pars.theta = min(theta_vec) + rand*range(theta_vec);
    end    
end
    
  


