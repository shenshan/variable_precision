
exp_id = 6;
% model_names = {'CP','CPG','VP','VPG'};
model_names = {'XP','XPG','XPVP','XPVPG'};

key2.lower_bound = [0.3,0.01,0.001,0,0];
key2.upper_bound = [0.7,1,1,10,0.5];
key2.plb = [0.4,0.01,0.01,0,0];
key2.pub = [0.6,0.5,0.7,5,0.2];
key2.start_point = [0.5,0.1,0.1,1,0.02];

for ii = 1:length(model_names)
    model_name = model_names{ii};
    
    if ismember(exp_id,[3,5,7,10,11])
        switch model_name
            case 'CP'
                idx = [1,2,2,2,2];
            case 'CPG'
                idx = [1,2,2,2,2,5];
            case 'VP'
                idx = [1,2,2,2,2,3];
            case 'VPG'
                idx = [1,2,2,2,2,3,5];
            case 'XP'
                idx = [1,2,2,2,2,4];
            case 'XPG'
                idx = [1,2,2,2,2,4,5];
            case 'XPVP'
                idx = [1,2,2,2,2,3,4];
            case 'XPVPG'
                idx = [1,2,2,2,2,3,4,5];
        end
    else
        switch model_name
            case 'CP'
                idx = 1:2;
            case 'CPG'
                idx = [1,2,5];
            case 'VP'
                idx = 1:3;
            case 'VPG'
                idx = [1:3,5];
            case 'XP'
                idx = [1,2,4];
            case 'XPG'
                idx = [1,2,4,5];
            case 'XPVP'
                idx = 1:4;
            case 'XPVPG'
                idx = 1:5;
        end
    end
    key = getValues(key2,idx);
    key.model_name = model_name;
    key.exp_id = exp_id;
    insert(varprecision.ParamsRange,key)
end

