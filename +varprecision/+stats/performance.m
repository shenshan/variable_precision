function [mean_perform, sem_perform] = performance(exp_res)
%PERFORMANCE shows the mean and std of the performance across subjects in this experiment
%   function [mean_perform, sem_perform] = performance(exp_res)
%   exp_res specifies the experiment number

performance = fetchn(varprecision.Performance & exp_res, 'avg_perf');

mean_perform = mean(performance);
sem_perform = std(performance)/sqrt(length(performance));

