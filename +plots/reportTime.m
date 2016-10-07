function reportTime(varargin)
%REPORTTIME report relative running time of each model

models = fetchn(varprecision.NormTimeModel & varargin,'model_name');
models = unique(models);

timeMat = cell(1,length(models));
for ii = 1:length(models)
    model = models{ii};
    key_rel = fetch(varprecision.NoiseMeasure & varargin & 'trial_num_sim = 2000' & ['model_name="' model '"']);
    timeMat{ii} = fetchn(varprecision.NormTimeModel & key_rel, 'norm_run_time');
end
time_mean = cellfun(@mean,timeMat);
time_sem = cellfun(@computeSEM,timeMat);

fig = Figure(111, 'size',[80,50]); hold on
bar(time_mean,'FaceColor',[0.8,0.8,0.8])
errorbar(1:length(models),time_mean,time_sem,'ko')
ylim([0,2])
set(gca,'xTick',1:length(models))
set(gca,'xTickLabel',models)
xlabel('models')
ylabel('normalized running time')
fig.cleanup

end

% helper function

function sem = computeSEM(data)  
    sem = std(data)/sqrt(length(data));
end


