
exp_id = 11;
model_names = {'CPN','CPGN','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'};
% model_names = {'XP','XPG','XPVP','XPVPG'};
% model_names = {'XPVP','XPVPG'};
% model_names = {'XPVPG'};

key2.lower_bound = [0.2,0.0001,0.000001,0,0,0];
key2.upper_bound = [0.8,1,1,10,0.5,10];
key2.plb = [0.4,0.01,0.01,0,0,0.00001];
key2.pub = [0.6,0.3,0.2,5,0.2,0.2];
% key2.start_point = [0.5,0.03,0.01,0.5,0.005];

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
            case {'OP','XP'}
                idx = [1,2,2,2,2,4];
            case {'OPG','XPG'}
                idx = [1,2,2,2,2,4,5];
            case {'OPVP','XPVP'}
                idx = [1,2,2,2,2,3,4];
            case {'OPVPG','XPVPG'}
                idx = [1,2,2,2,2,3,4,5];
            case 'CPN'
                idx = [1,2,2,2,2,6];
            case 'CPGN'
                idx = [1,2,2,2,2,5,6];
            case 'VPN'
                idx = [1,2,2,2,2,3,6];
            case 'VPGN'
                idx = [1,2,2,2,2,3,5,6];
            case 'OPN'
                idx = [1,2,2,2,2,4,6];
            case 'OPGN'
                idx = [1,2,2,2,2,4,5,6];
            case 'OPVPN'
                idx = [1,2,2,2,2,3,4,6];
            case 'OPVPGN'
                idx = [1,2,2,2,2,3,4,5,6];
                
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
            case {'OP','XP'}
                idx = [1,2,4];
            case {'OPG','XPG'}
                idx = [1,2,4,5];
            case {'OPVP','XPVP'}
                idx = 1:4;
            case {'OPVPG','XPVPG'}
                idx = 1:5;
            case 'CPN'
                idx = [1,2,6];
            case 'CPGN'
                idx = [1,2,5,6];
            case 'VPN'
                idx = [1,2,3,6];
            case 'VPGN'
                idx = [1,2,3,5,6];
            case 'OPN'
                idx = [1,2,4,6];
            case 'OPGN'
                idx = [1,2,4,5,6];
            case 'OPVPN'
                idx = [1,2,3,4,6];
            case 'OPVPGN'
                idx = [1,2,3,4,5,6];
        end
    end
    key = getValues(key2,idx);
    key.model_name = model_name;
    key.exp_id = exp_id;
    insert(varprecision.ParamsRange,key)
end

