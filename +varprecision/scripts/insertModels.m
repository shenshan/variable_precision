model_names = {'CP','CPG','VP','VPG'};
for iKey = fetch(varprecision.Experiment)'
    key = iKey;
    for iName = 1:length(model_names)
        key.model_name = model_names{iName};
        insert(varprecision.Model, key)
    end
end