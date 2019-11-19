function BetaTau(varargin)

%     exp_id = fetch1(varprecision.Experiment & varargin, 'exp_id');
    subjs = fetch(varprecision.Subject & 'subj_type = "real"');
    betas_OPG = fetchn(varprecision.FitParsEviBpsBest & subjs & varargin & 'model_name = "OPG"','beta_hat');
    betas_OPVPG = fetchn(varprecision.FitParsEviBpsBest & subjs & varargin & 'model_name = "OPVPG"', 'beta_hat');
    
    taus_VPG = fetchn(varprecision.FitParsEviBpsBest & subjs & varargin & 'model_name = "VPG"','theta_hat');
    
    fig = Figure(101,'size',[80,60]);
    hold on
    plot(betas_OPG, taus_VPG, 'ro');
    plot(betas_OPVPG, taus_VPG, 'bo');
    xlim([0,3])
    ylim([0,0.5])
%     set(gca,'XTick',0:1:3)
    
    xlabel('beta in OPG models');
    ylabel('tau in VPG model');
    legend('OPG','OPVPG','Location','Northeast')
    fig.cleanup
%     fig.save(['~/Dropbox/VR/+varprecision/figures/exp_' num2str(exp_id) '_beta_tau'])
    fig.save('~/Dropbox/VR/+varprecision/figures/all_exp_beta_tau')



