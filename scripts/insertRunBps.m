subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch(varprecision.InitialPoint & subjs & 'model_name in ("XPVP","XPVPG")' & 'exp_id = 7' & 'int_point_id in (1,2,3)');

for iKey = keys'
    iKey.run_idx = 2;
    iKey.trial_num_sim = 2000;
    insert(varprecision.RunBps, iKey)

end