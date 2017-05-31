
exp_id = 9;
% model_names = {'CP','CPN','CPG','CPGN','VP','VPN','VPG','VPGN','OP','OPN','OPG','OPGN','OPVP','OPVPN','OPVPG','OPVPGN'};
% model_names = {'XP','XPG','XPVP','XPVPG'};
% model_names = {'XPVP','XPVPG'};
% model_names = {'XPVPG'};
% model_names = {'OPVPGSum','OPVPGMax','OPVPGMin','OPVPGVar','OPVPGSign'};


% factors = {'','N','GN','O','NO','GO','GNO','VP','GVP','NVP','GNVP','OVP','NOVP','GNOVP'};
% rules = {'Sum','Min','Max','Var'};

% factors = {'','O','GO','VP','GVP','OVP'};
% rules = {'Sign'};
% 
% model_names = cell(length(factors),length(rules));
% 
% for ii = 1:length(factors)
%     for jj = 1:length(rules)
%         model_names{ii,jj} = [factors{ii} rules{jj}];
%     end
% end
% 
% model_names = reshape(model_names,[1,length(factors)*length(rules)]);

model_names = fetchn(varprecision.Model & 'model_name="GNOVar"','model_name');

key2.lower_bound = [0.2,0.0001,0.000001,0,0,0];
key2.upper_bound = [0.8,1,1,10,1,20];
key2.plb = [0.4,0.01,0.01,0,0,0.00001];
key2.pub = [0.6,0.3,0.2,5,0.2,0.5];
% key2.start_point = [0.5,0.03,0.01,0.5,0.005];

for ii = 1:length(model_names)
    model_name = model_names{ii};
    
    if ismember(exp_id,[3,5,7,10,11,12])
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
            case {'Sum','Max','Min','Var','Sign'}
                idx = 2;
            case {'GSum','GMax','GMin','GVar','GSign'}
                idx = [2,5];
            case {'NSum','NMax','NMin','NVar','NSign'}
                idx = [2,6];
            case {'GNSum','GNMax','GNMin','GNVar','GNSign'}
                idx = [2,5,6];
            case {'OSum','OMax','OMin','OVar','OSign'}
                idx = [2,4];
            case {'GOum','GOMax','GOMin','GOVar','GOSign'}
                idx = [2,4,5];
            case {'NOSum','NOMax','NOMin','NOVar','NOSign'}
                idx = [2,4,6];
            case {'GNOSum','GNOMax','GNOMin','GNOVar','GNOSign'}
                idx = [2,4,5,6];
            case {'VPSum','VPMax','VPMin','VPVar','VPSign'}
                idx = [2,3];
            case {'GVPSum','GVPMax','GVPMin','GVPVar','GVPSign'}
                idx = [2,3,5];
            case {'NVPSum','NVPMax','NVPMin','NVPVar','NVPSign'}
                idx = [2,3,6];
            case {'GNVPSum','GNVPMax','GNVPMin','GNVPVar','GNVPSign'}
                idx = [2,3,5,6];
            case {'OVPSum','OVPMax','OVPMin','OVPVar','OVPSign'}
                idx = [2,3,4];
            case {'GOVPSum','GOVPMax','GOVPMin','GOVPVar','GOVPSign'}
                idx = [2,3,4,5];
            case {'NOVPSum','NOVPMax','NOVPMin','NOVPVar','NOVPSign'}
                idx = [2,3,4,6];
            case {'GNOVPSum','GNOVPMax','GNOVPMin','GNOVPVar','GNOVPSign'}
                idx = [2,3,4,5,6];
        end
    end
    key = getValues(key2,idx);
    key.model_name = model_name;
    key.exp_id = exp_id;
    insert(varprecision.ParamsRange,key)
end

