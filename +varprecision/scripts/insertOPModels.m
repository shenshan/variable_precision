keys = fetch(varprecision.Experiment & 'exp_id in (1,2,3,4,5,7,8,9,10)');

for key = keys'
    
    if ismember(key.exp_id, [3,5,7,10,11])
        npars = 5;
    else
        npars = 2;
    end
    
    key.model_name = 'CPN';
    key.npars = npars + 1;
    insert(varprecision.Model,key);
    key.model_name = 'CPGN';
    key.npars = npars + 2;
    insert(varprecision.Model,key);
    key.model_name = 'VPN';
    key.npars = npars + 2;
    insert(varprecision.Model,key);
    key.model_name = 'VPGN';
    key.npars = npars + 3;
    insert(varprecision.Model,key);
    key.model_name = 'OPN';
    key.npars = npars + 2;
    insert(varprecision.Model,key);
    key.model_name = 'OPGN';
    key.npars = npars + 3;
    insert(varprecision.Model,key);
    key.model_name = 'OPVPN';
    key.npars = npars + 3;
    insert(varprecision.Model,key);
    key.model_name = 'OPVPGN';
    key.npars = npars + 4;
    insert(varprecision.Model,key);
end