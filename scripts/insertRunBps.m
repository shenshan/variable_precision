% subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch(varprecision.InitialPoint);

for iKey = keys'
    iKey.run_idx = 1;
    iKey.trial_num_sim = 5000;
    insert(varprecision.RunBps, iKey)

end