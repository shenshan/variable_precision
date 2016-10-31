subjs = fetch(varprecision.Subject & 'subj_type="real_sub"');
keys = fetch(varprecision.InitialPoint & subjs & 'exp_id = 7' & 'int_point_id in (1)');

for iKey = keys'
    iKey.run_idx = 1;
    iKey.trial_num_sim = 2000;
    insert(varprecision.RunBps, iKey)

end