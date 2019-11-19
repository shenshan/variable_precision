models = fetch(varprecision.Model & 'exp_id = 9');

for iModel = models'
    
    rule = fetch1(varprecision.Model & iModel, 'rule');
    
    if ~isempty(strfind(iModel.model_name,'SumErf'))
        update(varprecision.Model & iModel, 'model_type','SumErf')
    elseif ~isempty(strfind(iModel.model_name,'SumX'))
        update(varprecision.Model & iModel, 'model_type','SumX')
    elseif ~isempty(strfind(iModel.model_name,'Max')) && ~strcmp(iModel.model_name,'Max')
        update(varprecision.Model & iModel, 'model_type','Max')
    elseif ismember(rule,{'Sum','Max','Min','Var','Sign'})
        update(varprecision.Model & iModel, 'model_type','Simple')
    end
end