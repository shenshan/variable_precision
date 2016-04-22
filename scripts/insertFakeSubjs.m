% insert fake subjects into the subject table

model_names = {'CP','CPG','VP','VPG'};
fake_ids = 1:20;

for ii = 1:length(model_names)
    key.model_name = model_names{ii};
    for jj = 1:length(fake_ids)
        key.subj_type = 'fake';
        key.fake_idx = fake_ids(jj);
        key.subj_sex = 'Unknown';
        key.subj_initial = [key.model_name '_' num2str(key.fake_idx)];
        insert(varprecision.Subject, key);
    end
end