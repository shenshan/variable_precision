function [diff_mean, diff_sem, diff_mat] = showDiffFPGVP(evi_type, err_type, exp, varargin)
%SHOWDIFFFPGVP calculates and shows the difference
%   function [diff_mean, diff_sem, diff_mat] = showDiffFPGVP(evi_type,err_type, exp, varargin)
%   evi_type specifies the type of evidence, lml, aic, bic, aicc, llmax
%   err_type specifies the type of error, either sem or bootstrapped confidence interval (sem, bs)
%   exp specifies experiment of interest. eg. 'exp_id=1'

assert(ismember(evi_type,{'lml','aic','bic','aicc','llmax'}), 'evi_type should be one of the following: lml,aic,bic,aicc,llmax')
assert(ismember(err_type,{'sem','bs'}), 'err_type should be one of the following: sem, bs')

subjs = fetch(varprecision.Subject & 'subj_type="real"');
evi_FPG = fetchn(varprecision.FitParametersEvidence & exp & subjs & varargin & 'model_name="CPG"', evi_type);
evi_VP = fetchn(varprecision.FitParametersEvidence & exp & subjs & varargin & 'model_name="VP"', evi_type);

diff_mat = evi_VP - evi_FPG;

if strcmp(err_type,'sem')
    diff_mean = mean(diff_mat);
    diff_sem = std(diff_mat)/sqrt(length(diff_mat));
else
    % bootstrapped mean and sem. Basis: central limit theorem, the mean of
    % any distribution is approximately a Gaussian distribution with large
    % number of samples
    bs_mean = bootstrp(1000,@mean,diff_mat);
    diff_mean = mean(bs_mean);
    diff_sem = std(bs_mean);
end
    

