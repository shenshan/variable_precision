function FactorizedModelComparison(exp,type)
%FACTORIZEDMODELCOMPARISON shows the model comparison results, for final
%paper

exp = fetch(varprecision.Experiment & exp);
subjs = fetch(varprecision.Subject & 'subj_type="real"');

if strcmp(type,'all')
    models = {'CP','CPN','CPG','CPGN','VP','VPN','VPG','VPGN','OP','OPN','OPG','OPGN','OPVP','OPVPN','OPVPG','OPVPGN'};
    model_names = {'CF','CFN','CFG','CFGN','CV','CVN','CVG','CVGN','OF','OFN','OFG','OFGN','OV','OVN','OVG','OVGN'};
elseif strcmp(type,'dn')
    models = {'CPN','CPGN','VPN','VPGN','OPN','OPGN','OPVPN','OPVPGN'};
    model_names = {'CFN','CFGN','CVN','CVGN','OFN','OFGN','OVN','OVGN'};
else
    models = {'CP','CPG','VP','VPG','OP','OPG','OPVP','OPVPG'};
    model_names = {'CF','CFG','CV','CVG','OF','OFG','OV','OVG'};
end

mean_evi = zeros(1,length(models));

sem_evi = zeros(1,length(models));

if ismember(type,{'all','dn'})
    eviRef = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & 'model_name = "OPVPGN"','aic');
else
    eviRef = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & 'model_name = "OPVPG"','aic');
end

for ii = 1:length(models)

    eviMat = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & ['model_name="' models{ii} '"'],'aic');
    eviMat = eviMat - eviRef;
    
    mean_evi(ii) = mean(eviMat);
    sem_evi(ii) = std(eviMat)/sqrt(length(eviMat));
end

if length(models)>10
    fig = Figure(110,'size',[160,35]);
else
    fig = Figure(110,'size',[120,35]);
end

hold on

for ii = 1:length(mean_evi)
    
    bar(ii, 2*mean_evi(ii),'FaceColor','w')
    
end

errorbar(2*mean_evi,2*sem_evi,'k','LineStyle','None')

set(gca, 'XTick',1:length(models),'XTickLabel',model_names)
yLim = get(gca,'yLim');
if yLim(2)<100
    ylim([-20,100])
else
    ylim([-20,yLim(2)])
end

xlabel('Models')
ylabel('aic')

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/exp_' num2str(exp.exp_id) '_aic_' type])

