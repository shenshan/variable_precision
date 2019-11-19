function showLLMat(varargin)

keys = fetch(varprecision.LogLikelihoodMat & varargin);

for iKey = keys'
    LLMat = fetch1(varprecision.LogLikelihoodMat & iKey, 'll_mat');
    pars = fetch(varprecision.ParameterSet & iKey,'*');
    figure;
    switch pars.model_name
        case 'CP'
           imagesc(LLMat');
           set(gca,'XTick',1:length(pars.p_right),'XTickLabel',round(pars.p_right*100)/100);
           set(gca,'YTick',1:length(pars.lambda),'YTickLabel',round(pars.p_right*100)/100);
        case 'CPG'
        case 'VP'
        case 'VPG'
    end
end

