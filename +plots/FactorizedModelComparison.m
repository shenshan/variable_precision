function FactorizedModelComparison(exp,cmp_type,model_type,avg)
%FACTORIZEDMODELCOMPARISON shows the model comparison results, for final
%paper

exp = fetch(varprecision.Experiment & exp);
subjs = fetch(varprecision.Subject & 'subj_type="real"');

if ~exist('avg','var')
    avg = 'best';
end

if strcmp(model_type,'all')
    models = {'CP','CPG','CPN','CPGN','OP','OPG','OPN','OPGN','VP','VPG','VPN','VPGN','OPVP','OPVPG','OPVPN','OPVPGN'};
    model_names = {'Base','G','D','GD','O','GO','DO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV'};
elseif strcmp(model_type,'dn')
    models = {'CPN','CPGN','OPN','OPGN','VPN','VPGN','OPVPN','OPVPGN'};
    model_names = {'D','GD','DO','GDO','DV','GDV','DOV','GDOV'};
else
    models = {'CP','CPG','OP','OPG','VP','VPG','OPVP','OPVPG'};
    model_names = {'Base','G','V','VG','O','OG','OV','OVG'};
end

mean_evi = zeros(1,length(models));

sem_evi = zeros(1,length(models));

if ismember(model_type,{'all','dn'})
    
    if strcmp(avg, 'avg')
        eviRef = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & 'model_name = "OPVPGN"',cmp_type);
    else
        eviRef = fetchn(varprecision.FitParsEviBpsBest & exp & subjs & 'model_name = "OPVPGN"',cmp_type);
    end
    
else
    if strcmp(avg, 'avg')
        eviRef = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & 'model_name = "OPVPG"',cmp_type);
    else
        eviRef = fetchn(varprecision.FitParsEviBpsBest & exp & subjs & 'model_name = "OPVPG"',cmp_type);
    end
end

for ii = 1:length(models)
    
    if strcmp(avg,'avg')
        eviMat = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & ['model_name="' models{ii} '"'],cmp_type);
    else
        eviMat = fetchn(varprecision.FitParsEviBpsBest & exp & subjs & ['model_name="' models{ii} '"'],cmp_type);
    end
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
    fig = Figure(110,'size',[120,35]);
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
        ylim([-20,yLim(2)])
    end
else
    if yLim(1)>-50
        ylim([-50,10])
    else
        ylim([yLim(1),10])
    end
end

xlabel('Model')
ylabel(upper(cmp_type))

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/exp_' num2str(exp.exp_id) '_' cmp_type '_' model_type])

