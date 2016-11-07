keys = fetch(varprecision.Experiment & 'exp_id in (1,2,3,4,5)');

for key = keys'
    key.model_name = 'OP';
    key.npars = 3;
    insert(varprecision.Model,key);
    key.model_name = 'OPG';
    key.npars = 4;
    insert(varprecision.Model,key);
    key.model_name = 'OPVP';
    key.npars = 4;
    insert(varprecision.Model,key);
    key.model_name = 'OPVPG';
    key.npars = 5;
    insert(varprecision.Model,key);
end