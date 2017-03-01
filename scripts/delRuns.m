exps = fetch(varprecision.Experiment & 'exp_id=10');
subjs = fetch(varprecision.Subject & 'subj_type="real"');

models = {'CP','CPG','CPN','CPGN'};

for exp = exps'
    
    subjs_rel = fetch(varprecision.Recording & exp & subjs);
    
    for subj = subjs_rel'
       
        llmax_opvpgn = fetch1(varprecision.FitParsEviBpsBest & exp & subj & 'model_name="OPGN"','llmax');
        
        for ii = 1:length(models)
            model = models{ii};
            del(varprecision.FitParsEviBpsRun & subj & ['model_name="' model '"'] & ['llmax>' num2str(llmax_opvpgn+1)])
        end
        
    end
    
end