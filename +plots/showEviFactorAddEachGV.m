function showEviFactorAddEachGV(type)
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
            [eviMat{ii,1},eviMat{ii,2}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_aic','var_aic');
        case 'bic'
            [eviMat{ii,1},eviMat{ii,2}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_bic','var_bic');
        case 'aicc'
            [eviMat{ii,1},eviMat{ii,2}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_aicc','var_aicc');
        case 'llmax'
            [eviMat{ii,1},eviMat{ii,2}] = fetchn(varprecision.EviFactorAddEach & exp, 'guess_llmax','var_llmax');
    end
    
end

fig = Figure(101,'size',[150,30]);
eviMat = cellfun(@(x)2*x, eviMat,'Un',0);
groupbar(eviMat)
hold on
ylim([-20,110])
set(gca,'YTick',-20:20:100)

xLim = get(gca, 'xLim');  
plot([xLim(1),xLim(2)],[6.8,6.8],'k--');
plot([xLim(1),xLim(2)],[9.21,9.21],'k--')
plot([xLim(1),xLim(2)],[4.6,4.6],'k--')


% xlabel('Experiment number')
ylabel('KID')

% legend('+G','+D','+O','+V','+O+V','location','northeast')

fig.cleanup

fig.save(['~/Dropbox/VR/+varprecision/figures/evi_factor_add_each_GV_' type])

