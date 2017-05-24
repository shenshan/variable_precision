initial_point_vec = [0.5,0.01,0.005,1,0.1,0.1];

% initial_point_vec = [0.5,0.006,0.002,0.002,0.0007,0.0004,1,0.001,0.16];

subj_type = 'real';
% subjs = fetch(varprecision.Subject & ['subj_type="' subj_type '"'] & 'model_gene="OPVPG"');

subjs = fetch(varprecision.Subject & ['subj_type="' subj_type '"']); 
keys = fetch((varprecision.Recording & subjs) * varprecision.ParamsRange & 'exp_id in (9)' & 'model_name in ("GSum","GMax","GMin","GVar","GSign")');

for iKey = keys'
    iKey.int_point_id=3;
    if ~ismember(iKey.exp_id,[3,5,7,10,11,12]) || strcmp(subj_type,'real_sub')
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
            case {'GSum','GMax','GMin','GVar','GSign'}
                iKey.initial_point = initial_point_vec([2,5]);
            case {'OPVPGSum','OPVPGMax','OPVPGMin','OPVPGVar','OPVPGSign'}
                iKey.initial_point = initial_point_vec(2:5);
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

