function showExpectedProbInd(exp)
%FACTORIZEDMODELCOMPARISON shows the model comparison results, for final
%paper

model_names = {'Base','V','G','GV','O','GO','OV','GOV','D','DV','GD','GDV','OD','GOD','ODV','GODV'};

exp_rMat = varprecision.utils.decell(fetchn(varprecision.BmcGroup & exp,'pxp'));

fig = Figure(110,'size',[200,35]);

hold on

for ii = 1:length(exp_rMat)
    bar(ii, exp_rMat(ii),'FaceColor','w')
end
set(gca, 'XTick',1:length(model_names),'XTickLabel',model_names)

ylim([0,0.5])
xLim = get(gca, 'xLim');
plot([xLim(1),xLim(2)],[1/16,1/16],'k--')

xlabel('Model')
ylabel('Expected probability')

fig.cleanup
fig.save(['~/Dropbox/VR/+varprecision/figures/' exp])

