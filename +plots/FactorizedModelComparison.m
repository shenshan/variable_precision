function FactorizedModelComparison(exp)
%FACTORIZEDMODELCOMPARISON shows the model comparison results, for final
%paper

exp = fetch(varprecision.Experiment & exp);
subjs = fetch(varprecision.Subject & 'subj_type="real"');
models = {'CP','CPG','VP','VPG','OP','OPG','OPVP','OPVPG'};
model_names = {'CF','CFG','CV','CVG','OF','OFG','OV','OVG'};

mean_evi = zeros(1,length(models));

sem_evi = zeros(1,length(models));

eviRef = fetchn(varprecision.FitParsEviBpsBest & exp & subjs & 'model_name = "OPVPG"','aic');

for ii = 1:length(models)

    eviMat = fetchn(varprecision.FitParsEviBpsBest & exp & subjs & ['model_name="' models{ii} '"'],'aic');
    eviMat = eviMat - eviRef;
    
    mean_evi(ii) = mean(eviMat);
    sem_evi(ii) = std(eviMat)/sqrt(length(eviMat));
end

fig = Figure(110,'size',[80,35]); hold on

for ii = 1:length(mean_evi)
    
%     if ismember(ii,[1,2])
%         b = bar(ii, mean_evi(ii),'FaceColor',[1,0.8,0.8]);
%     elseif ismember(ii,[3,4])
%         b = bar(ii, mean_evi(ii),'FaceColor','r');
%     elseif ismember(ii,[5,6])
%         b = bar(ii, mean_evi(ii),'FaceColor',[0.8,0.8,1]);
%     else
%         b = bar(ii, mean_evi(ii),'FaceColor','b');
%     end
%     
%     if ismember(ii,[2,4,6,8])
%         center = get(b,'XData');
%         w = get(b,'BarWidth');
%         h = get(b,'YData');
%         x = [center - w/2, center + w/2];
%         y = [0,h];
%         if mean_evi(ii)<0
%             y = [h,0];
%         end
%         plot(x,y,'k--')
%     end
    bar(ii, 2*mean_evi(ii),'FaceColor','w')
    
end

errorbar(2*mean_evi,2*sem_evi,'k','LineStyle','None')

set(gca, 'XTick',1:length(models),'XTickLabel',model_names)
yLim = get(gca,'yLim');
if yLim(2)<60
    ylim([yLim(1),60])
end

xlabel('Models')
ylabel('aic')

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/exp_' num2str(exp.exp_id) '_aic'])

