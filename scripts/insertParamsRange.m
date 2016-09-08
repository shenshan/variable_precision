
model_names = {'CP','CPG','VP','VPG'};

key2.lower_bound = [0.3,0.01,0.001,0];
key2.upper_bound = [0.7,1,1,0.5];
key2.plb = [0.4,0.01,0.01,0];
key2.pub = [0.6,0.5,0.7,0.2];
key2.start_point = [0.5,0.1,0.1,0.02];

for ii = 1:length(model_names)
    model_name = model_names{ii};
    
    switch model_name
        case 'CP'
            idx = 1:2;
        case 'CPG'
            idx = [1,2,4];
        case 'VP'
            idx = 1:3;
        case 'VPG'
            idx = 1:4;
    end
    key = getValues(key2,idx);
    key.model_name = model_name;
    key.exp_id = 2;
    insert(varprecision.ParamsRange,key)
end

