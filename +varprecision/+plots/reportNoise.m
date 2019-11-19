function reportNoise(varargin)
%REPORTNOISE shows the noise as a function of simulation trial number

    trial_number = fetchn(varprecision.NoiseMeasure & varargin, 'trial_num_sim');
    trial_number_vec = unique(trial_number);

    % noise and time of all models
    stdMat = cell(1,length(trial_number_vec));
    timeMat = cell(1,length(trial_number_vec));
    for ii = 1:length(trial_number_vec)
        ntrials = trial_number_vec(ii);
        key_rel = fetch(varprecision.NoiseMeasure & varargin & ['trial_num_sim = ' num2str(ntrials)]);
        stdMat{ii} = fetchn(varprecision.NoiseMeasure & key_rel,'ll_mat_std');
        timeMat{ii} = fetchn(varprecision.NormTime & key_rel,'norm_run_time');
    end
    
    noise_mean = cellfun(@mean, stdMat);
    noise_sem = cellfun(@computeSEM, stdMat);
    
    time_mean = cellfun(@mean,timeMat);
    time_sem = cellfun(@computeSEM,timeMat);
    
    fig = Figure(110, 'size',[80,50]);
    errorbar(trial_number_vec,noise_mean,noise_sem,'o-')
    set(gca,'xTick',trial_number_vec)
    xlabel('simulation trial number')
    ylabel('standard deviation of LL')
    fig.cleanup
    
    fig2 = Figure(111, 'size',[80,50]);
    errorbar(trial_number_vec,time_mean,time_sem,'o-')
    ylim([0,5])
    set(gca,'xTick',trial_number_vec)
    xlabel('simulation trial number')
    ylabel('normalized running time')
    fig2.cleanup
    
    % noise and time of individual models  
    models = fetchn(varprecision.NoiseMeasure & varargin,'model_name');
    models = unique(models);
    
    fig3 = Figure(112, 'size',[300,100]);
    nRows = 2; nCols = ceil(length(models)/2);
    
    for ii = 1:length(models)
        subplot(nRows, nCols, ii);
        model = models{ii};
        for jj = 1:length(trial_number_vec)
            ntrials = trial_number_vec(jj);
            stdMat{jj} = fetchn(varprecision.NoiseMeasure & varargin & ['trial_num_sim = ' num2str(ntrials)],'ll_mat_std');
        end
        noise_mean = cellfun(@mean, stdMat);
        noise_sem = cellfun(@computeSEM, stdMat);
        errorbar(trial_number_vec,noise_mean,noise_sem,'o-')
        set(gca,'xTick',trial_number_vec)
        xlabel('simulation trial number')
        ylabel('standard deviation of LL')
        title(model)
    end
    fig3.cleanup
    
    fig4 = Figure(113, 'size',[300,100]);
    nRows = 2; nCols = ceil(length(models)/2);
    
    for ii = 1:length(models)
        subplot(nRows, nCols, ii);
        model = models{ii};
        for jj = 1:length(trial_number_vec)
            ntrials = trial_number_vec(jj);
            key_rel = fetch(varprecision.NoiseMeasure & varargin & ['trial_num_sim = ' num2str(ntrials)]);
            timeMat{jj} = fetchn(varprecision.NormTime & key_rel,'norm_run_time');
        end
        time_mean = cellfun(@mean, timeMat);
        time_sem = cellfun(@computeSEM, timeMat);
        errorbar(trial_number_vec,time_mean,time_sem,'o-')
        ylim([0,5
            ])
        set(gca,'xTick',trial_number_vec)
        xlabel('simulation trial number')
        ylabel('normalized running time')
        title(model)
    end
    fig4.cleanup


end


% helper function

function sem = computeSEM(data)  
    sem = std(data)/sqrt(length(data));
end

