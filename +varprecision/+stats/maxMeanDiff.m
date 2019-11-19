function max_diff = maxMeanDiff(exp_res, type, varargin)
%MAXMEANDIFF returns the maximum difference in evidence quantities amongst
%models
% SS 17-04-21

if ~exist('type','var')
    type = 'aic';
end

exp = fetch(varprecision.Experiment & exp_res);
subjs = fetch(varprecision.Subject & 'subj_type="real"');

models = fetch(varprecision.Model & exp & varargin);

eviMat = zeros(1,length(models));

for ii = 1:length(models)
    eviMat(ii) = mean(fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & models(ii), type));
    
end

if ismember(type,{'aic','bic','aicc'})
    eviMat = eviMat*2;
end

max_diff = range(eviMat);