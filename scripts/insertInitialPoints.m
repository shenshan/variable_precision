initial_point_vec= [0.5,0.1,0.05,1,0.02];

subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch((varprecision.Recording & subjs) * varprecision.ParamsRange & 'exp_id=6');

for iKey = keys'
    iKey.int_point_id=1;
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
    insert(varprecision.InitialPoint, iKey)

end

