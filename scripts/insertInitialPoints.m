initial_point_vec = [0.5,0.05,0.01,1,0.02];

subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch((varprecision.Recording & subjs) * varprecision.ParamsRange & 'exp_id=11');

for iKey = keys'
    iKey.int_point_id=1;
    if ~ismember(iKey.exp_id,[3,5,7,10,11])
        switch iKey.model_name
            case 'CP'
                iKey.initial_point = initial_point_vec(1:2);
            case 'CPG'
                iKey.initial_point = initial_point_vec([1:2,5]);
            case 'VP'
                iKey.initial_point = initial_point_vec(1:3);
            case 'VPG'
                iKey.initial_point = initial_point_vec([1:3,5]);
            case 'XP'
                iKey.initial_point = initial_point_vec([1,2,4]);
            case 'XPG'
                iKey.initial_point = initial_point_vec([1,2,4,5]);
            case 'XPVP'
                iKey.initial_point = initial_point_vec(1:4);
            case 'XPVPG'
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
            case 'XP'
                iKey.initial_point = initial_point_vec([1,2,2,2,2,4]);
            case 'XPG'
                iKey.initial_point = initial_point_vec([1,2,2,2,2,4,5]);
            case 'XPVP'
                iKey.initial_point = initial_point_vec([1,2,2,2,2,3,4]);
            case 'XPVPG'
                iKey.initial_point = initial_point_vec([1,2,2,2,2,3,4,5]);
        end
    end
    insert(varprecision.InitialPoint, iKey)

end

