function showPerformOriAllModels
%SHOWPERFORMORI shows the performance of exp8 as a function of reference orientation
% function showPerformOri(varargin)
% the input specifies the models

subjs = fetch(varprecision.Subject & 'subj_type = "real"');
recordings = fetch(varprecision.Recording & 'exp_id = 8' & subjs);

bins = -90:10:90;

% compute performance 
performMat = zeros(length(recordings),length(bins));

for ii = 1:length(recordings)
    [stimuli, performance] = fetch1(varprecision.Performance & recordings(ii), 'stimuli', 'performance');
    
    idx = interp1(bins,1:length(bins),stimuli(:,2),'nearest','extrap');
    
    for jj = 1:length(bins);
        performMat(ii,jj) = mean(performance(idx==jj));
    end
    
end

mean_perf = mean(performMat);
sem_perf = std(performMat)/sqrt(length(recordings));

% compute performance for models
models = {'CP','VP','CPG','VPG','OP','OPVP','OPG','OPVPG','CPN','VPN','CPGN','VPGN','OPN','OPVPN','OPGN','OPVPGN'};
model_names = {'Base','V','G','GV','O','OV','GO','GOV','D','DV','GD','GDV','OD','ODV','GOD','GODV'};

fig = Figure(301, 'size', [48*4+3,27*4]);

for ii = 1:length(models)
    model = fetch(varprecision.Model & 'exp_id=8' & ['model_name="' models{ii} '"']);
    model_name = model_names{ii};
    model_performMat = zeros(length(recordings),length(bins));
    for jj = 1:length(recordings)
        stimuli = fetch1(varprecision.Performance & recordings(jj), 'stimuli');
        model_performance = fetch1(varprecision.PerformanceModel & recordings(jj) & model, 'performance');
        idx = interp1(bins,1:length(bins),stimuli(:,2),'nearest','extrap');
        for kk = 1:length(bins);
            model_performMat(jj,kk) = mean(model_performance(idx==kk));
        end
    end
    perform_patch = varprecision.utils.getUpperLowerBound(model_performMat,1);

    subplot(4,4,ii); hold on
    patch([bins,wrev(bins)],perform_patch,[0.8,0.8,0.8],'LineStyle','None')
    errorbar(bins,mean_perf,sem_perf,'k','LineStyle','None')
    text(30,0.9,model_name)
    ylim([0.5,1])
    xlim([-90,90])

    set(gca,'XTick',-90:45:90,'YTick',0.5:0.1:1)
end
fig.cleanup
fig.save('~/Dropbox/VR/+varprecision/figures/exp8_model_fits_performance_all.eps')

