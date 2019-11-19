subjs = fetch(varprecision.Subject & 'subj_type= "real"');

models = fetch(varprecision.Model & 'prior_type in ("Flat")');
keys = fetch(varprecision.InitialPoint & subjs & 'exp_id in (4)' & models);

for iKey = keys'
    if ~isempty(fetch(varprecision.RunBps & iKey))
        continue
    end
    iKey.run_idx = 1;
    iKey.trial_num_sim = 2000;
    insert(varprecision.RunBps, iKey)

end