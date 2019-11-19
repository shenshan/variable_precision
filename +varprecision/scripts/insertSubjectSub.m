
subj_real = fetch(varprecision.Subject & 'subj_type = "real"');

keys_rec = fetch(varprecision.Recording & 'exp_id = 11' & subj_real,'*');

setsizes = [1,2,4,8];

for ii = 1:length(keys_rec)
    
    key = fetch(varprecision.Subject & ['subj_initial="' keys_rec(ii).subj_initial '"']);
    initial = key.subj_initial;
    key_rec = keys_rec(ii);
    for jj = 1:length(setsizes)
        setsize = setsizes(jj);
        key.subj_initial = [initial '_ss_' num2str(setsize)];
        key.set_size = setsize;
        key.subj_type = 'real_sub';
        key_rec.subj_initial = key.subj_initial;
        
        tuple = fetch(varprecision.Subject & ['subj_initial="' key.subj_initial '"']);
        if isempty(tuple)
            insert(varprecision.Subject,key)
        end
        insert(varprecision.Recording, key_rec)
    end
end
