function showLFLRAllExps(type)

exp_ids = [1,8,2:5,9,10,6,7,11];

for iexp = exp_ids
    
    switch type
        case 'aic'
            [g,o,d,v,ov] = fetchn(varprecision.EviFactor & ['exp_id=' num2str(iexp)], 'g_lfpr_aic','o_lfpr_aic','d_lfpr_aic','v_lfpr_aic','ov_lfpr_aic');
        case 'bic'
            [g,o,d,v,ov] = fetchn(varprecision.EviFactor & ['exp_id=' num2str(iexp)], 'g_lfpr_bic','o_lfpr_bic','d_lfpr_bic','v_lfpr_bic','ov_lfpr_bic');
    end
    g = g*2; d = d*2; o = o*2; v = v*2; ov = ov*2; 

    fid = fopen(['LFLR_' type '.txt'],'a');
    fprintf(fid,['%5.2f ',177,' %5.2f, %5.2f ', 177, ' %5.2f, %5.2f ', 177, ' %5.2f, %5.2f ', 177, ' %5.2f, %5.2f ', 177, ' %5.2f\n'], ...
        mean(g), std(g)/sqrt(length(g)),mean(o), std(o)/sqrt(length(o)),mean(d), std(d)/sqrt(length(d)),mean(v), std(v)/sqrt(length(v)),mean(ov), std(ov)/sqrt(length(ov)));
    fclose(fid);
    
end