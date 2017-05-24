function showModelComparisonSub(cmp_type)
%SHOWMODELCOMPARISONSUB shows the model comparison results for suboptimal
%model for exp9

exp = fetch(varprecision.Experiment & 'exp_id=9');
subjs = fetch(varprecision.Subject & 'subj_type="real"');
models = {'GSum','GMax','GMin','GVar','GSign','CPG','OPVPGSum','OPVPGMax','OPVPGMin','OPVPGVar','OPVPGSign'};

model_names = {'SumG','MaxG','MinG','VarG','SignG','OptG','SumGOV','MaxGOV','MinGOV','VarGOV','SignGOV'};

mean_evi = zeros(1,length(models));
sem_evi = zeros(1,length(models));

eviRef = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & 'model_name = "OPVPG"',cmp_type);

for ii = 1:length(models)
    eviMat = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & ['model_name="' models{ii} '"'],cmp_type);
    eviMat = eviMat - eviRef;
    
    mean_evi(ii) = mean(eviMat);
    sem_evi(ii) = std(eviMat)/sqrt(length(eviMat));
end

if ismember(cmp_type, {'aic','bic','aicc'})
    mean_evi = 2*mean_evi;
    sem_evi = 2*sem_evi;
end

if length(models)>10
    fig = Figure(110,'size',[200,35]);
else
    fig = Figure(110,'size',[90,35]);
end

hold on

for ii = 1:length(mean_evi)
    bar(ii, mean_evi(ii),'FaceColor','w')
end

errorbar(mean_evi,sem_evi,'k','LineStyle','None')

set(gca, 'XTick',1:length(models),'XTickLabel',model_names)
yLim = get(gca,'yLim');

if ismember(cmp_type,{'aic','bic','aicc'})
    if yLim(2)<100
        ylim([-20,100])
    else
        ylim([0,yLim(2)])
    end
else
    if yLim(1)>-50
        ylim([-50,10])
    else
        ylim([yLim(1),10])
    end
end

xlabel('Model')
ylabel([upper(cmp_type) ' relative to OptGOV'])

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/exp_' num2str(exp.exp_id) '_' cmp_type '_sub'])