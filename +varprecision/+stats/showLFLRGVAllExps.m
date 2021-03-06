function showLFLRGVAllExps(type)

exp_ids = [1,8,2:5,9,10,6,7,11];

for iexp = exp_ids
    
    switch type
        case 'aic'
            [g,v] = fetchn(varprecision.EviFactorGV & ['exp_id=' num2str(iexp)], 'g_lfpr_aic','v_lfpr_aic');
        case 'bic'
            [g,v] = fetchn(varprecision.EviFactorGV & ['exp_id=' num2str(iexp)], 'g_lfpr_bic','v_lfpr_bic');
    end
    g = g*2; v = v*2;

    fid = fopen(['LFLR_GV_' type '.txt'],'a');
    fprintf(fid,['%5.2f ',177,' %5.2f, %5.2f ', 177, ' %5.2f\n'], ...
        mean(g), std(g)/sqrt(length(g)), mean(v), std(v)/sqrt(length(v)));
    fclose(fid);
    
end