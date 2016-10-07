subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch(varprecision.InitialPoint & 'int_point_id=5');

for iKey = keys'
    iKey.run_idx = 1;
    iKey.trial_num_sim = 2000;
    insert(varprecision.RunBps, iKey)

end