subjs = fetch(varprecision.Subject & 'subj_type= "real"');
keys = fetch(varprecision.InitialPoint & subjs & 'exp_id in (7)' & 'model_name in ("VPGN")' & 'subj_initial="TA"');

for iKey = keys'
    if ~isempty(fetch(varprecision.RunBps & iKey))
        continue
    end
    iKey.run_idx = 1;
    iKey.trial_num_sim = 2000;
    insert(varprecision.RunBps, iKey)

end