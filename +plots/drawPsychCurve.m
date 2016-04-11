function drawPsychCurve(type,varargin)
%DRAWPSYCHCURVE Draw psychometric curve for a given model
%   type specifies data, model or both

assert(ismember(type,{'data','both'}),'Invalid input for type, please enter one of the three: data or both.')

keys = fetch(varprecision.FitPrediction & varargin);
exps = fetch(varprecision.Experiment & keys);

for ii = 1:length(exps)
    
    exp = exps(ii);
    subjs = fetch(varprecision.Subject & exp & keys);
    models = fetch(varprecision.Model & exp & keys);
       
    if length(subjs)==1
        [p_right,stims] = fetch1(varprecision.DataStats & exp & keys,'p_right','stims');
       
    else
        [p_right,stims] = fetchn(varprecision.DataStats & exp & keys, 'p_right','stims');
        stims = [stims{1}];
        p_right = [p_right{:}];
        p_right_mean = mean(p_right,2);
        p_right_sem = std(p_right,[],2)./sqrt(size(p_right,2));
    end
    
    figure; hold on
    
    if strcmp(type,'data')
        if length(subjs)==1
            plot(stims,p_right,'ko')
        else
            errorbar(stims,p_right_mean,p_right_sem,'k.','LineStyle','None')
        end
    elseif strcmp(type,'both')
        if length(models)==1
            if length(subjs)==1
                fit_pred = fetch1(varprecision.FitPrediction & exp & keys,'prediction_plot');
                plot(stims,p_right,'k.')
                plot(stims,fit_pred,'k')
            else 
                fit_pred = fetchn(varprecision.FitPrediction & exp & keys,'prediction_plot');
                fit_pred = [fit_pred{:}];
                fit_patch = varprecision.utils.getUpperLowerBound(fit_pred,2);
                patch([stims;wrev(stims)]',fit_patch',[0.8,0.8,0.8],'LineStyle','None');
                plot(stims,p_right,'k.');
            end
        else
            for jj = 1:length(models)
                if length(models)==4
                    subplot(2,2,jj)
                else
                    subplot(1,length(models),jj)
                end
                hold on
                model = models(jj);
                if length(subjs)==1;
                    fit_pred = fetch1(varprecision.FitPrediction & exp & keys & model, 'prediction_plot');
                    plot(stims, p_right, 'k.')
                    plot(stims, fit_pred, 'k')
                
                else
                    fit_pred = fetchn(varprecision.FitPrediction & exp & keys & model,'prediction_plot');
                    fit_pred = [fit_pred{:}];
                    fit_patch = varprecision.utils.getUpperLowerBound(fit_pred,2);
                    patch([stims;wrev(stims)]',fit_patch',[0.8,0.8,0.8],'LineStyle','None')
                    errorbar(stims,p_right_mean,p_right_sem,'k.','LineStyle','None');
                end
            end
                
        end
    end
    
    
 
end


