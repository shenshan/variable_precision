function pars = generateFakeParams(mode,varargin)
%GENERATEFAKEPARAMS generates a single set of parameters, for later on fake
%data generation
%   mode specifies the way to generate fake parameters, random or based on
%   real subject parameters
%   varargin should contain exp_id, model_name.

assert(ismember(mode,{'real','random'}),'Invalid mode input, please enter real or random.')
keys1 = fetch(varprecision.FitParametersEvidence & varargin);
if strcmp(mode,'random')
    assert(~isempty(keys1), 'Real fitting parameters does not exist.')
end
keys2 = fetch(varprecision.ParameterSet & varargin);
assert(~isempty(keys2),'No paramter set found. Please check the validity of the inputs.')
models = fetch(varprecision.Model & varargin,'*');
assert(length(models)==1,'Please make sure that only one experiment and model is included.')

pars_set = fetch(varprecision.ParameterSet & varargin, '*');
if strcmp(mode,'real')
    [p_right,lambda,theta,guess] = fetchn(varprecision.FitParametersEvidence & varargin, 'p_right_hat','lambda_hat','theta_hat','guess_hat');
    
    [p_right_mean,p_right_std] = varprecision.utils.getMeanStd(p_right,'std');
    if iscell(lambda)
        lambda = varprecision.utils.decell(lambda);
        [lambda_mean,lambda_std] = varprecision.utils.getMeanStd(lambda,'std',3);
    else
        [lambda_mean,lambda_std] = varprecision.utils.getMeanStd(lambda,'std');
    end
    pars.p_right = max(p_right_mean + p_right_std*randn, min(pars_set.p_right));
    pars.lambda = max(lambda_mean + lambda_std*randn, min(pars_set.lambda)); 
    
    if ismember(models.model_name,{'CPG','VPG'})
        [guess_mean,guess_std] = varprecision.utils.getMeanStd(guess);
        pars.guess = max(guess_mean + guess_std*randn, min(pars_set.guess));
    end
    
    if ismember(models.model_name,{'VP','VPG'})
        [theta_mean,theta_std] = varprecision.utils.getMeanStd(theta);
        pars.theta = max(theta_mean + theta_std*randn, min(pars_set.theta));
    end    
else
    
    pars.p_right = min(pars_set.p_right) + rand*range(pars_set.p_right);
    
    exp = fetch(varprecision.Experiment & keys2);
    if ismember(exp.exp_id,[3,5,7])
        setsize = fetch1(varprecision.Experiment & models,'setsize');
        pars.lambda = repmat(pars_set.lambda,1,length(setsize)) + rand*range(pars_set.lambda);
    else
        pars.lambda = min(pars_set.lambda) + rand*range(pars_set.lambda);
    end
    
    if ismember(models.model_name,{'CPG','VPG'})
        pars.guess = min(pars_set.guess) + rand*range(pars_set.guess);
    end
    
    if ismember(models.model_name,{'VP','VPG'})
        pars.theta = min(pars_set.theta) + rand*range(pars_set.theta);
    end    
end
    
  


