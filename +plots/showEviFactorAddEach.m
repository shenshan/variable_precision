function showEviFactorAddEach(type)
%SHOWEVIFACTORAdd shows the factor evidence for all experiments
%   function showEviFactor(type)
%   type specifies the type of evidences, should be one of the following: aic, bic, aicc, llmax

exp_ids = [1,8,2:5,9,10,6,7,11];

eviMat = cell(length(exp_ids),3);

for ii = 1:length(exp_ids)
    exp_id = exp_ids(ii);
    exp = fetch(varprecision.Experiment & ['exp_id =' num2str(exp_id)]);
    
    switch type
        case 'aic'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4},eviMat{ii,5}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_aic','ori_aic','dn_aic','var_aic','total_var_aic');
        case 'bic'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4},eviMat{ii,5}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_bic','ori_bic','dn_bic','var_bic','total_var_bic');
        case 'aicc'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4},eviMat{ii,5}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_aicc','dn_aicc','ori_aicc','var_aicc','total_var_aicc');
        case 'llmax'
            [eviMat{ii,1},eviMat{ii,2},eviMat{ii,3},eviMat{ii,4},eviMat{ii,5}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_llmax','dn_llmax','ori_llmax','var_llmax','total_var_llmax');
    end
    
end

fig = Figure(101,'size',[150,30]);
eviMat = cellfun(@(x)-2*x, eviMat,'Un',0);
groupbar(eviMat)

ylim([-120,20])

% xlabel('Experiment number')
ylabel([upper(type) ' difference'])

% legend('+G','+D','+O','+V','+O+V','location','northeast')

fig.cleanup

fig.save(['~/Dropbox/VR/+varprecision/figures/evi_factor_add_each_' type])

