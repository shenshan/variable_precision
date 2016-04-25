function showConfusionMatrix(mode,type,varargin)
%SHOWCONFUSIONMATRIX shows the ConfusionMatrix of fake data test
%   function showConfusionMatrix(mode,varargin)
%   mode specifies the method that was used to generate fake data parameters.
%   type specifies which type of evidence to plot
%   varargin includes restriction of experiments and model

assert(ismember(mode,{'real','random'}), 'Invalid input for mode, please enter real or random.')
assert(ismember(type,{'aic','bic','aicc','lml','llmax'}), 'Invalid input for type, please enter one of the following: aic, bic, aicc, lml, llmax.')

subjs = fetch(varprecision.Subject & 'subj_type="fake"' & ['fake_param_method="' mode '"']);
key_res = fetch(varprecision.FitParametersEvidence & varargin);
exps = fetch(varprecision.Experiment & key_res);

for iexp = exps'
    models = fetch(varprecision.Model & iexp & key_res);
    model_names = fetchn(varprecision.Model & iexp & key_res, 'model_name');
    
    confMat = zeros(length(models),length(models));
    confdiag = zeros(1,length(models));
    for ii = 1:length(models)
        imodel1 = models(ii);
        subjs_sub = fetch(varprecision.Subject & subjs & ['model_gene="' imodel1.model_name '"']);
        for jj = 1:length(models)
            imodel2 = models(jj);
            evi = fetchn(varprecision.FitParametersEvidence & imodel2 & subjs_sub, type);
            confMat(ii,jj) = mean(evi);
        end
        confdiag(ii) = confMat(ii,ii);
    end
    confMat = bsxfun(@minus, confMat, confdiag);
    
    fig = Figure(105, 'size',[60,40]);
    
    imagesc(confMat); colorbar
    set(gca, 'XTick', 1:length(models), 'YTick', 1:length(models),'XTickLabel', model_names, 'YTickLabel', model_names)
    xlabel('Fitting models'); ylabel('Models to generate data')
    fig.cleanup
    
end

