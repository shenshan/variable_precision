% This script inserts fake data information into the Recording Table

exps = fetch(varprecision.Experiment & 'exp_id in (6,7,11)');
subjs = fetch(varprecision.Subject & 'subj_type="fake"' & 'fake_idx<11');

for exp = exps'
    for subj = subjs'
        key.exp_id = exp.exp_id;
        key.subj_initial = subj.subj_initial;
        insert(varprecision.Recording, key)
    end
end
