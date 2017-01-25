
nIntPoints = 10;
exps = fetch(varprecision.Experiment);
subjs = fetch(varprecision.Subject & 'subj_type = "real"');


for exp = exps'
    models = fetch(varprecision.Model & exp & 'model_name in ("CP","CPG","VP","VPG","OP","OPG","OPVP","OPVPG")');
    
    for imodel = models'
        [plb,pub] = fetch1(varprecision.ParamsRange & exp & imodel,'plb','pub');
        param_range = pub - plb;
        keys = fetch((varprecision.Recording & subjs) * varprecision.ParamsRange & imodel & exp);
        
        for ikey = keys'
            int_point_idx = max(fetchn(varprecision.InitialPoint & ikey,'int_point_id'));
            for ii = 1:nIntPoints
                ikey.int_point_id = int_point_idx + ii;
                ikey.initial_point = plb + rand(size(pub)).*param_range;
                insert(varprecision.InitialPoint, ikey)
            end
        end
    end
    

end