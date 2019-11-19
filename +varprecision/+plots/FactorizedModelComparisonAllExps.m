function FactorizedModelComparisonAllExps(cmp_type)
%FACTORIZEDMODELCOMPARISON shows the model comparison results, for final
%paper

models = {'CP','VP','CPG','VPG','OP','OPG','OPVP','OPVPG','CPN','VPN','CPGN','VPGN','OPN','OPGN','OPVPN','OPVPGN'};
model_names = {'Base','V','G','GV','O','GO','OV','GOV','D','DV','GD','GDV','OD','GOD','ODV','GODV'};


evi = zeros(1,length(models));

eviRef = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & 'model_name="OPVPGN"',cmp_type);


for ii = 1:length(models)
    
    evi(ii) = fetch1(varprecision.FitParsEviBpsBestAvgAllExps & ['model_name="' models{ii} '"'],cmp_type) - eviRef;  
    
end

if ismember(cmp_type, {'aic','bic','aicc'})
    evi = 2*evi;
end
   
if length(models)>10
    fig = Figure(110,'size',[200,35]);
else
    fig = Figure(110,'size',[120,35]);
end

hold on

for ii = 1:length(evi)
    bar(ii, evi(ii),'FaceColor','w')
end
set(gca, 'XTick',1:length(models),'XTickLabel',model_names)
% yLim = get(gca,'yLim');
% 
% if ismember(cmp_type,{'aic','bic','aicc'})
%     if yLim(2)<100
%         ylim([-20,100])
%     else
%         ylim([-20,yLim(2)])
%     end
% else
%     if yLim(1)>-50
%         ylim([-50,10])
%     else
%         ylim([yLim(1),10])
%     end
% end

xlabel('Model')
ylabel(upper(cmp_type))

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/all_exps_' cmp_type])

