subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch(varprecision.InitialPoint & subjs & 'exp_id in (8)' & 'int_point_id in (1,2,3)');

for iKey = keys'
    iKey.run_idx = 2;
    iKey.trial_num_sim = 5000;
    insert(varprecision.RunBps, iKey)

end
