initial_point_vec = [0.5,0.1,0.02,0,0.1,0];

% initial_point_vec = [0.5,0.006,0.002,0.002,0.0007,0.0004,1,0.001,0.16];

subj_type = 'real';
% subjs = fetch(varprecision.Subject & ['subj_type="' subj_type '"'] & 'model_gene="OPVPG"');

% 
% factors = {'','N','GN','O','NO','GO','GNO','VP','GVP','NVP','GNVP','OVP','NOVP','GNOVP'};
% rules = {'Sum','Min','Max','Var'};

% factors = {'','O','GO','VP','GVP','OVP'};
% rules = {'Sign'};
% 
% str = [];
% for ii = 1:length(factors)
%     for jj = 1:length(rules)
%         model_name= [factors{ii} rules{jj}];
%         
%         if ii==1 && jj==1
%             str = [str '"' model_name '"'];
%         else
%             str = [str ',"' model_name '"'];
%         end   
%     end
% end
% 
% models = fetch(varprecision.Model & 'model_type="sub"');

subjs = fetch(varprecision.Subject & ['subj_type="' subj_type '"']);

models = fetch(varprecision.Model & 'model_type="sub"');
keys = fetch((varprecision.Recording & subjs) * varprecision.ParamsRange & 'exp_id in (9)' & models);

for iKey = keys'
    iKey.int_point_id=3;
    if ~isempty(fetch(varprecision.InitialPoint & iKey))
        continue
    end
    
    [model_type, factor_code] = fetch1(varprecision.Model & iKey, 'model_type','factor_code');
    
    if ~ismember(iKey.exp_id,[3,5,7,10,11,12]) || strcmp(subj_type,'real_sub')
        
        if strcmp(model_type,'opt')
            switch iKey.model_name
                case 'CP'
                    iKey.initial_point = initial_point_vec(1:2);
                case 'CPG'
                    iKey.initial_point = initial_point_vec([1:2,5]);
                case 'VP'
                    iKey.initial_point = initial_point_vec(1:3);
                case 'VPG'
                    iKey.initial_point = initial_point_vec([1:3,5]);
                case {'OP','XP'}
                    iKey.initial_point = initial_point_vec([1,2,4]);
                case {'OPG','XPG'}
                    iKey.initial_point = initial_point_vec([1,2,4,5]);
                case {'OPVP','XPVP'}
                    iKey.initial_point = initial_point_vec(1:4);
                case {'OPVPG','XPVPG'}
                    iKey.initial_point = initial_point_vec(1:5);
                case 'CPN'
                    iKey.initial_point = initial_point_vec([1:2,6]);
                case 'CPGN'
                    iKey.initial_point = initial_point_vec([1:2,5,6]);
                case 'VPN'
                    iKey.initial_point = initial_point_vec([1:3,6]);
                case 'VPGN'
                    iKey.initial_point = initial_point_vec([1:3,5,6]);
                case 'OPN'
                    iKey.initial_point = initial_point_vec([1,2,4,6]);
                case 'OPGN'
                    iKey.initial_point = initial_point_vec([1,2,4,5,6]);
                case 'OPVPN'
                    iKey.initial_point = initial_point_vec([1:4,6]);
                case 'OPVPGN'
                    iKey.initial_point = initial_point_vec;
            end
        else
            switch factor_code
            case 'Base'
                iKey.initial_point = initial_point_vec(2);
            case 'G'
                iKey.initial_point = initial_point_vec([2,5]);
            case 'D'
                iKey.initial_point = initial_point_vec([2,6]);
            case 'GD'
                iKey.initial_point = initial_point_vec([2,5,6]);
            case 'O'
                iKey.initial_point = initial_point_vec([2,4]);
            case 'GO'
                iKey.initial_point = initial_point_vec([2,4,5]);
            case 'DO'
                iKey.initial_point = initial_point_vec([2,4,6]);
            case 'GDO'
                iKey.initial_point = initial_point_vec([2,4,5,6]);
            case 'V'
                iKey.initial_point = initial_point_vec([2,3]);
            case 'GV'
                iKey.initial_point = initial_point_vec([2,3,5]);
            case 'DV'
                iKey.initial_point = initial_point_vec([2,3,6]);
            case 'GDV'
                iKey.initial_point = initial_point_vec([2,3,5,6]);
            case 'OV'
                iKey.initial_point = initial_point_vec([2,3,4]);
            case 'GOV'
                iKey.initial_point = initial_point_vec(2:5);
            case 'DOV'
                iKey.initial_point = initial_point_vec([2,3,4,6]);
            case 'GDOV'
                iKey.initial_point = initial_point_vec(2:6);
            end
        end
    else
        switch iKey.model_name
%             case 'CP'
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2]);
%             case 'CPG'
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2,5]);
%             case 'VP'
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2,3]);
%             case 'VPG'
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2,3,5]);
%             case {'OP','XP'}
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2,4]);
%             case {'OPG','XPG'}
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2,4,5]);
%             case {'OPVP','XPVP'}
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2,3,4]);
%             case {'OPVPG','XPVPG'}
%                 iKey.initial_point = initial_point_vec([1,2,2,2,2,3,4,5]);
            case 'CP'
                iKey.initial_point = initial_point_vec(1:5);
            case 'CPG'
                iKey.initial_point = initial_point_vec([1:5,8]);
            case 'VP'
                iKey.initial_point = initial_point_vec(1:6);
            case 'VPG'
                iKey.initial_point = initial_point_vec([1:6,8]);
            case {'XP','OP'}
                iKey.initial_point = initial_point_vec([1:5,7]);
            case {'XPG','OPG'}
                iKey.initial_point = initial_point_vec([1:5,7,8]);
            case {'XPVP','OPVP'}
                iKey.initial_point = initial_point_vec(1:7);
            case {'XPVPG','OPVPG'}
                iKey.initial_point = initial_point_vec(1:8);
            case 'CPN'
                iKey.initial_point = initial_point_vec([1:5,9]);
            case 'CPGN'
                iKey.initial_point = initial_point_vec([1:5,8,9]);
            case 'VPN'
                iKey.initial_point = initial_point_vec([1:6,9]);
            case 'VPGN'
                iKey.initial_point = initial_point_vec([1:6,8,9]);
            case 'OPN'
                iKey.initial_point = initial_point_vec([1:5,7,9]);
            case 'OPGN'
                iKey.initial_point = initial_point_vec([1:5,7,8,9]);
            case 'OPVPN'
                iKey.initial_point = initial_point_vec([1:7,9]);
            case 'OPVPGN'
                iKey.initial_point = initial_point_vec(1:9);
                
        end
    end
    insert(varprecision.InitialPoint, iKey)

end

