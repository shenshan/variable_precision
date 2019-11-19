exp_ids = [1,8,2:5,9,10,6,7,11];

for ii = 1:length(exp_ids)
    
    [prior_mean, prior_sem, l_mean, l_sem, g_mean, g_sem, o_mean, o_sem, d_mean, d_sem, v_mean, v_sem] = ...
        fetch1(varprecision.AvgParsGodv & ['exp_id = ' num2str(exp_ids(ii))], ...
    'prior_mean', 'prior_sem', 'lambda_mean', 'lambda_sem', 'guess_mean', 'guess_sem', 'beta_mean', 'beta_sem', 'sigma_dn_mean', 'sigma_dn_sem', 'theta_mean', 'theta_sem');
    
    fid = fopen('fit_pars.txt','a');
    fprintf(fid,['%5.3f ',177,' %5.3f, %5.3f ', 177, ' %5.3f, %5.3f ', 177, ' %5.3f, %5.3f ', 177, ' %5.3f, %5.3f ', 177, ' %5.3f\n'], ...
        prior_mean, prior_sem, g_mean, g_sem, o_mean, o_sem, d_mean, d_sem, v_mean, v_sem);
    
    l_mean
    l_sem
    
    fclose(fid);
end