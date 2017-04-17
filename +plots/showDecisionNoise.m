function showDecisionNoise(type)
%SHOWDECISIONNOISE shows the estimated sigma_decision_noise across
%experiments
% type specifies three modes, decision noise of CPGN, OPVPGN or the best
% fitting models
% exp_rel specifies the experiments involved in the plot

exp_ids = [1,8,2:5,9,10,6,11];

subjs = fetch(varprecision.Subject & 'subj_type="real"');

dnMat = cell(1,length(exp_ids));

for ii = 1:length(exp_ids)
    exp_id = exp_ids(ii);
    exp = fetch(varprecision.Experiment & ['exp_id="' num2str(exp_id) '"']);
    
    if ismember(type, {'CPGN','OPVPGN'})        
        dnMat{ii} = fetchn(varprecision.FitParsEviBpsBest & exp & subjs & ['model_name="' type '"'],'sigma_dn_hat');
       
    else
        subjs_rel = fetch(varprecision.Recording & exp & subjs);
        dnMat_subj = zeros(1,length(subjs_rel));
        for jj = 1:length(subjs_rel)
            [llmax_mat,model_names] = fetchn(varprecision.FitParsEviBpsBest & exp & subjs_rel(jj) & 'model_name in ("CPN","CPGN","VPN","VPGN","OPN","OPGN","OPVPN","OPVPGN")','aic','model_name');
            [~,idx] = max(llmax_mat);
            
            dnMat_subj(jj) = fetch1(varprecision.FitParsEviBpsBest & exp & subjs_rel(jj) & ['model_name="' model_names{idx} '"'],'sigma_dn_hat');
        end
        dnMat{ii} = dnMat_subj;
        
    end    
    
end

dn_mean = cellfun(@mean, dnMat);
dn_std = cellfun(@std, dnMat);
dn_length = cellfun(@length, dnMat);
dn_sem = dn_std./sqrt(dn_length);


fig = Figure(301, 'size',[120,50]);

scatter(1:length(dnMat), dn_mean, 'ko'); hold on
errorbar(1:length(dnMat), dn_mean, dn_sem, 'k', 'LineStyle', 'None');

set(gca,'XTick',1:length(dnMat))
set(gca,'XTickLabel',{'1','2','3','4','5','6','7','8','9','11'})

ylim([0,1.5])

xlabel('Experiment number')
ylabel('Decision noise')

fig.cleanup

fig.save(['~/Dropbox/VR/+varprecision/figures/decision_noise_' type])
