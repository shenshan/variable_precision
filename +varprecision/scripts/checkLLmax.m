% check in all experiments, which subject has simpler model fits better

exps = fetch(varprecision.Experiment & 'exp_id=7');
subjs = fetch(varprecision.Subject & 'subj_type="real"');

models = {'CP','VPG','OP','OPG','VP','VPG','OPVP','OPVPG','CPN','VPGN','OPN','OPGN','VPN','VPGN','OPVPN','OPVPGN'};

for exp = exps'
    
    subjs_rel = fetch(varprecision.Recording & exp & subjs);
    
    for subj = subjs_rel'
       
        llmaxMat = zeros(1,length(models));
        llmax_opvpgn = fetch1(varprecision.FitParsEviBpsBest & exp & subj & 'model_name="OPVPGN"','llmax');
        
        for ii = 1:length(models)
            model = models{ii};
            llmaxMat(ii) = fetch1(varprecision.FitParsEviBpsBest & exp & subj & ['model_name="' model '"'], 'llmax');
        end
        
        if any(llmaxMat - llmax_opvpgn>1)      
            subj
            llmaxMat
            llmax_opvpgn
        end
        
    end
    
end