function showModelComparison2D(type)
%SHOWMODELCOMPARISON2D shows the AIC/BIC for all combinations of factors and rules for exp 9

factors = {'Base','V','G','GV','O','OV','GO','GOV','D','DV','GD','GDV','DO','DOV','GDO','GDOV'};
model_names = {'Base','V','G','GV','O','OV','GO','GOV','D','DV','GD','GDV','OD','ODV','GOD','GODV'};
rules = {'Sum','Max','Min','Var','Sign','Max2','Max12','Max13','Max23','Max123','SumErf','SumErf1','SumErf2','SumErf3','SumErf12','SumErf13','SumErf23','SumX1','SumX2','SumX3','SumX12','SumX13','SumX23','SumX123','Opt'};
subjs = fetch(varprecision.Subject & 'subj_type="real"');

eviMat = zeros(length(factors),length(rules));

for ii = 1:length(factors)
    for jj = 1:length(rules)
        
        model = fetch(varprecision.Model & 'exp_id = 9' & ['factor_code="' factors{ii} '"'] & ['rule="' rules{jj} '"']);
        
        evi = fetchn(varprecision.FitParsEviBpsBestAvg & subjs & model, type);
        if isempty(evi)
            eviMat(ii,jj) = NaN;
        else
            eviMat(ii,jj) = mean(evi);
        end
        
    end
end

eviMat = eviMat - nanmin(eviMat(:));
eviMat = reshape(eviMat,[1,numel(eviMat)]);
eviMat = 2*eviMat;
map = colormap('hot');

map = map(5:end-10,:);
close all
idx = interp1(linspace(nanmin(eviMat),nanmax(eviMat),length(map)),1:length(map),eviMat,'nearest','extrap');

ncolors = length(map);
map(ncolors+1,:) = [1,1,1];
idx(isnan(idx)) = ncolors + 1; 

fig = Figure(200,'size',[190,200]);
[x,y] = meshgrid(1:length(factors),1:length(rules));
x = reshape(x',[1,numel(x)]);
y = reshape(y',[1,numel(y)]);

gscatter(x,y,1:numel(x),map(idx,:),'.',[40,40,40],'off');
caxis([min(eviMat),max(eviMat)]); caxis([-50,850]);colorbar; colormap(map);hold on
set(gca,'xTick',1:length(factors),'xTickLabel',model_names)
set(gca,'yTick',1:length(rules),'yTickLabel',rules)
xlabel('Factor model')
ylabel('Decision rule')
fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/model_comparison_2d_' type '.eps'])



