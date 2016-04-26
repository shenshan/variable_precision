% This script inserts fake data information into the Recording Table

exps = fetch(varprecision.Experiment & 'exp_id in (4,5)');
subjs = fetch(varprecision.Subject & 'subj_type="fake"');

for exp = exps'
    for subj = subjs'
        key.exp_id = exp.exp_id;
        key.subj_initial = subj.subj_initial;
        insert(varprecision.Recording, key)
    end
end
