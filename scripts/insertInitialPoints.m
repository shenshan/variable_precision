initial_point_vec = [0.5,0.05,0.01,1,0.01];

% initial_point_vec = [0.5,0.1,0.05,0.03,0.01,0.05,3,0.01];

subj_type = 'real';
subjs = fetch(varprecision.Subject & ['subj_type="' subj_type '"']);
keys = fetch((varprecision.Recording & subjs) * varprecision.ParamsRange & 'model_name in ("OP","OPG","OPVP","OPVPG")' & 'exp_id in (1,2,3,4,5)');

for iKey = keys'
    iKey.int_point_id=1;
    if ~ismember(iKey.exp_id,[3,5,7,10,11]) || strcmp(subj_type,'real_sub')
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
                iKey.initial_point = initial_point_vec;
        end
    else
        switch iKey.model_name
            case 'CP'
                iKey.initial_point = initial_point_vec([1,2,2,2,2]);
            case 'CPG'
                iKey.initial_point = initial_point_vec([1,2,2,2,2,5]);
            case 'VP'
                iKey.initial_point = initial_point_vec([1,2,2,2,2,3]);
            case 'VPG'
                iKey.initial_point = initial_point_vec([1,2,2,2,2,3,5]);
            case {'OP','XP'}
                iKey.initial_point = initial_point_vec([1,2,2,2,2,4]);
            case {'OPG','XPG'}
                iKey.initial_point = initial_point_vec([1,2,2,2,2,4,5]);
            case {'OPVP','XPVP'}
                iKey.initial_point = initial_point_vec([1,2,2,2,2,3,4]);
            case {'OPVPG','XPVPG'}
                iKey.initial_point = initial_point_vec([1,2,2,2,2,3,4,5]);
%             case 'CP'
%                 iKey.initial_point = initial_point_vec(1:5);
%             case 'CPG'
%                 iKey.initial_point = initial_point_vec([1:5,8]);
%             case 'VP'
%                 iKey.initial_point = initial_point_vec(1:6);
%             case 'VPG'
%                 iKey.initial_point = initial_point_vec([1:6,8]);
%             case 'XP'
%                 iKey.initial_point = initial_point_vec([1:5,7]);
%             case 'XPG'
%                 iKey.initial_point = initial_point_vec([1:5,7,8]);
%             case 'XPVP'
%                 iKey.initial_point = initial_point_vec(1:7);
%             case 'XPVPG'
%                 iKey.initial_point = initial_point_vec(1:8);
                
        end
    end
    insert(varprecision.InitialPoint, iKey)

end

