function showPerformSetSize(exp)
%SHOWPERFORMSETSIZE show proportion correct as a function of set size

[setsizes, performance] = fetchn(varprecision.PerformanceSetsize & exp, 'setsizes', 'perform_ss');

setsizes = varprecision.utils.decell(setsizes(1));
performance = varprecision.utils.decell(performance);
[mean_perf, sem_perf] = varprecision.utils.getMeanStd(performance,'sem',2);

fig = Figure(101,'size',[50,30]);

errorbar(setsizes, mean_perf, sem_perf,'k.-')
set(gca,'XTick',setsizes,'yTick',0.5:0.1:1);
ylim([0.5,1])
p = anova1(performance')

fig.cleanup
fig.save('~/Dropbox/VR/+varprecision/figures/performance_ss_exp3.eps')