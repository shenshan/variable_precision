

subjs = fetch(varprecision.Subject & 'subj_type="real"');
theta_hat_6 = fetchn(varprecision.FitParametersEvidence & subjs & 'exp_id=6' & 'jkmap_id=2' & 'parset_id=2'& 'model_name="OP"','theta_hat');
theta_hat_7 = fetchn(varprecision.FitParametersEvidence & subjs & 'exp_id=7' & 'jkmap_id=2' & 'parset_id=5'& 'model_name="OP"','theta_hat');
theta_hat_11 = fetchn(varprecision.FitParametersEvidence & subjs & 'exp_id=11' & 'jkmap_id=2' & 'parset_id=4'& 'model_name="OP"','theta_hat');


[mean_theta_hatMat(1), sem_theta_hatMat(1)] = varprecision.utils.getMeanStd(theta_hat_6, 'sem');
[mean_theta_hatMat(2), sem_theta_hatMat(2)] = varprecision.utils.getMeanStd(theta_hat_7, 'sem');
[mean_theta_hatMat(3), sem_theta_hatMat(3)] = varprecision.utils.getMeanStd(theta_hat_11, 'sem');


fig1 = Figure(101,'size',[50,30]); hold on

bar(mean_theta_hatMat);
errorbar(mean_theta_hatMat, sem_theta_hatMat,'LineStyle','None')
set(gca,'XTick',1:3,'XTickLabel',{'Exp8','Exp9','Exp11'})
ylabel('beta')
fig1.cleanup
fig1.save('~/Dropbox/VR/+varprecision/figures/theta_hat_OP')

theta_hat_6 = fetchn(varprecision.FitParametersEvidence & subjs & 'exp_id=6' & 'jkmap_id=2' & 'parset_id=2'& 'model_name="OPG"','theta_hat');
theta_hat_7 = fetchn(varprecision.FitParametersEvidence & subjs & 'exp_id=7' & 'jkmap_id=2' & 'parset_id=5'& 'model_name="OPG"','theta_hat');
theta_hat_11 = fetchn(varprecision.FitParametersEvidence & subjs & 'exp_id=11' & 'jkmap_id=2' & 'parset_id=4'& 'model_name="OPG"','theta_hat');


[mean_theta_hatMat(1), sem_theta_hatMat(1)] = varprecision.utils.getMeanStd(theta_hat_6, 'sem');
[mean_theta_hatMat(2), sem_theta_hatMat(2)] = varprecision.utils.getMeanStd(theta_hat_7, 'sem');
[mean_theta_hatMat(3), sem_theta_hatMat(3)] = varprecision.utils.getMeanStd(theta_hat_11, 'sem');



fig2 = Figure(102,'size',[50,30]); hold on

bar(mean_theta_hatMat);
errorbar(mean_theta_hatMat, sem_theta_hatMat,'LineStyle','None')
set(gca,'XTick',1:3,'XTickLabel',{'Exp8','Exp9','Exp11'})
ylabel('beta')
fig2.cleanup
fig2.save('~/Dropbox/VR/+varprecision/figures/theta_hat_OPG')
