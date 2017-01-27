subjs = fetch(varprecision.Subject & 'subj_type= "real"');
keys = fetch(varprecision.InitialPoint & subjs & 'exp_id in (1,2,3,4,5,7,8,9,10)' & 'model_name in ("CPN","CPGN","VPN","VPGN","OPN","OPGN","OPVPN","OPVPGN")');

for iKey = keys'
    if ~isempty(fetch(varprecision.RunBps & iKey))
        continue
    end
    iKey.run_idx = 1;
    iKey.trial_num_sim = 2000;
    insert(varprecision.RunBps, iKey)

end