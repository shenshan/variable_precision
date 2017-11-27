function showModelComparisionOptMin(exp,cmp_type)
%FACTORIZEDMODELCOMPARISON shows the model comparison results, for final
%paper

exp = fetch(varprecision.Experiment & exp);
subjs = fetch(varprecision.Subject & 'subj_type="real"');

models = {'CP','VP','CPG','VPG','OP','OPVP','OPG','OPVPG','CPN','VPN','CPGN','VPGN','OPN','OPVPN','OPVPG','OPVPGN'};
models_sub = {'BaseMin','VMin','GMin','GVMin','OMin','OVMin','GOMin','GOVMin','DMin','DVMin','GDMin','GDVMin','DOMin','DOVMin','GOVMin','GDOVMin'};
model_names = {'Base','V','G','GV','O','OV','GO','GOV','D','DV','GD','GDV','OD','ODV','GOV','GODV'};

eviMat = cell(2,length(models));
 
eviRef = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & 'model_name = "OPVPGN"',cmp_type);


for ii = 1:length(models)
    
    eviMat{1,ii} = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & ['model_name="' models{ii} '"'],cmp_type)-eviRef;
    eviMat{2,ii} = fetchn(varprecision.FitParsEviBpsBestAvg & exp & subjs & ['model_name="' models_sub{ii} '"'],cmp_type)-eviRef;
end

if ismember(cmp_type, {'aic','bic','aicc'})
    eviMat = cellfun(@(x) 2*x, eviMat, 'Un',0);
end
   
if length(models)>10
    fig = Figure(110,'size',[200,35]);
else
    fig = Figure(110,'size',[120,35]);
end

hold on

groupbar(eviMat')

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
fig.save(['~/Dropbox/VR/+varprecision/figures/exp_' num2str(exp.exp_id) '_' cmp_type '_OptMin'])

