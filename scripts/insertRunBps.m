subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch(varprecision.InitialPoint & 'exp_id = 11' & 'int_point_id in (2,3,4)');

for iKey = keys'
    iKey.run_idx = 1;
    iKey.trial_num_sim = 5000;
    insert(varprecision.RunBps, iKey)

end