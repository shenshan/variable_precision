
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

models = fetch(varprecision.Model & 'model_type in ("Simple","Max","SumX")','*');

key2.lower_bound = [0.2,0.0001,0.000001,0,0,0];
key2.upper_bound = [0.8,1,1,10,1,20];
key2.plb = [0.4,0.01,0.01,0,0,0.00001];
key2.pub = [0.6,0.3,0.2,5,0.2,0.5];
% key2.start_point = [0.5,0.03,0.01,0.5,0.005];

for ii = 1:length(models)
    model_name = models(ii).model_name;
    factor_code = models(ii).factor_code;
    model_type = models(ii).model_type;
    
    if ~isempty(fetch(varprecision.ParamsRange & models(ii)))
        continue
    end
    
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
        if ismember(model_type,{'opt','SumErf'})
            switch factor_code
                case 'Base'
                    idx = 1:2;
                case 'G'
                    idx = [1,2,5];
                case 'V'
                    idx = 1:3;
                case 'GV'
                    idx = [1:3,5];
                case 'O'
                    idx = [1,2,4];
                case 'GO'
                    idx = [1,2,4,5];
                case 'OV'
                    idx = 1:4;
                case 'GOV'
                    idx = 1:5;
                case 'D'
                    idx = [1,2,6];
                case 'GD'
                    idx = [1,2,5,6];
                case 'DV'
                    idx = [1,2,3,6];
                case 'GDV'
                    idx = [1,2,3,5,6];
                case 'DO'
                    idx = [1,2,4,6];
                case 'GDO'
                    idx = [1,2,4,5,6];
                case 'DOV'
                    idx = [1,2,3,4,6];
                case 'GDOV'
                    idx = [1,2,3,4,5,6];
            end
        else
            switch factor_code
                case 'Base'
                    idx = 2;
                case 'G'
                    idx = [2,5];
                case 'D'
                    idx = [2,6];
                case 'GD'
                    idx = [2,5,6];
                case 'O'
                    idx = [2,4];
                case 'GO'
                    idx = [2,4,5];
                case 'DO'
                    idx = [2,4,6];
                case 'GDO'
                    idx = [2,4,5,6];
                case 'V'
                    idx = [2,3];
                case 'GV'
                    idx = [2,3,5];
                case 'DV'
                    idx = [2,3,6];
                case 'GDV'
                    idx = [2,3,5,6];
                case 'OV'
                    idx = [2,3,4];
                case 'GOV'
                    idx = [2,3,4,5];
                case 'DOV'
                    idx = [2,3,4,6];
                case 'GDOV'
                    idx = [2,3,4,5,6];
            end
        end
    end
    key = getValues(key2,idx);
    key.model_name = model_name;
    key.exp_id = exp_id;
    insert(varprecision.ParamsRange,key)
end

