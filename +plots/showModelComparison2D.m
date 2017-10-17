function showModelComparison2D
%SHOWMODELCOMPARISON2D shows the AIC for all combinations of factors and rules for exp 9

factors = {'Base','G','D','GD','O','GO','DO','GDO','V','GV','DV','GDV','OV','GOV','DOV','GDOV'};
rules = {'Sum','Max','Min','Var','Sign','Max2','Max12','Max13','Max23','Max123','SumErf','SumErf1','SumErf2','SumErf3','SumErf12','SumErf13','SumErf23','SumX1','SumX2','SumX3','SumX12','SumX13','SumX23','SumX123','Opt'};
subjs = fetch(varprecision.Subject & 'subj_type="real"');

aicMat = zeros(length(factors),length(rules));

for ii = 1:length(factors)
    for jj = 1:length(rules)
        
        model = fetch(varprecision.Model & 'exp_id = 9' & ['factor_code="' factors{ii} '"'] & ['rule="' rules{jj} '"']);
        
        aic = fetchn(varprecision.FitParsEviBpsBestAvg & subjs & model, 'aic');
        if isempty(aic)
            aicMat(ii,jj) = NaN;
        else
            aicMat(ii,jj) = mean(aic);
        end
        
    end
end

aicMat = aicMat - nanmin(aicMat(:));
aicMat = reshape(aicMat,[1,numel(aicMat)]);

colormap_jet = colormap;
close all
idx = interp1(linspace(nanmin(aicMat),nanmax(aicMat),length(colormap_jet)),1:length(colormap_jet),aicMat,'nearest','extrap');

ncolors = length(colormap_jet);
colormap_jet(ncolors+1,:) = [1,1,1];
idx(isnan(idx)) = ncolors + 1; 

fig = Figure(200,'size',[200,200]);
[x,y] = meshgrid(1:length(factors),1:length(rules));
x = reshape(x',[1,numel(x)]);
y = reshape(y',[1,numel(y)]);

gscatter(x,y,1:numel(x),colormap_jet(idx,:),'.',[40,40,40],'off');
caxis([min(aicMat),max(aicMat)]); colorbar; hold on
set(gca,'xTick',1:length(factors),'xTickLabel',factors)
set(gca,'yTick',1:length(rules),'yTickLabel',rules)
xlabel('Factor')
ylabel('Decision rule')
fig.cleanup
fig.save('~/Dropbox/VR/+varprecision/figures/model_comparison_2d.eps')



