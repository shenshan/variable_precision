function drawPsychCurve(type,varargin)
%DRAWPSYCHCURVE Draw psychometric curve for a given model
%   type specifies data, model or both

assert(ismember(type,{'data','both','bps'}),'Invalid input for type, please enter one of the three: data or both.')

switch type
    case 'data'
        keys = fetch(varprecision.DataStats & varargin);
    case 'both'
        keys = fetch(varprecision.FitPrediction & varargin);
        
    case 'bps'
        keys = fetch(varprecision.FitPredictionBpsBest & varargin);
        
end
exps = fetch(varprecision.Experiment & keys);

for ii = 1:length(exps)
    
    exp = exps(ii);
    subjs = fetch(varprecision.Subject & exp & keys);
    models = fetch(varprecision.Model & exp & keys);
    setsizes = fetch1(varprecision.Experiment & exp & keys,'setsize');
       
    if length(subjs)==1
        [p_right,stims] = fetch1(varprecision.DataStats & exp & keys,'p_right','stims');
       
    else
        [p_right,stims] = fetchn(varprecision.DataStats & exp & keys, 'p_right','stims');
        stims = [stims{1}];
        [p_right,dim,len] = varprecision.utils.decell(p_right);
        p_right_mean = mean(p_right,dim);
        p_right_sem = std(p_right,[],dim)./sqrt(len);
    end
    if length(models)==6
        fig = Figure(102,'size',[140,60]);
    elseif length(models)==8
        fig = Figure(102,'size',[160,60]);
    else
        fig = Figure(102,'size',[48*length(models)+3,27]);
    end
        
        
    hold on
    xLim = max(stims)*1.1;
    text_x = -max(stims)*0.8;
    if strcmp(type,'data')
        if length(subjs)==1
            plot(stims,p_right,'o')
        else
            if length(setsizes)==1
                errorbar(stims,p_right_mean,p_right_sem,'k','LineStyle','None')
            else
                errorbar(repmat(stims,1,length(setsizes)),p_right_mean',p_right_sem')
            end
        end
        xlim([-xLim,xLim]);
        ylim([0,1])
    else
        if length(models)==1
            model_name = varprecision.utils.mapModelName(fetch1(varprecision.Model & keys));
            if length(subjs)==1
                if strcmp(type, 'both')
                    fit_pred = fetch1(varprecision.FitPrediction & exp & keys,'prediction_plot');
                elseif strcmp(type, 'bps')
                    fit_pred = fetch1(varprecision.FitPredictionBpsBest & exp & keys,'prediction_plot');
                end
                plot(stims,p_right,'o')
                plot(stims,fit_pred)
                
            else 
                if strcmp(type, 'both')
                    fit_pred = fetchn(varprecision.FitPrediction & exp & keys,'prediction_plot');
                elseif strcmp(type, 'bps')
                    fit_pred = fetchn(varprecision.FitPredictionBpsBest & exp & keys,'prediction_plot');
                end
                [fit_pred, dim] = varprecision.utils.decell(fit_pred);
                fit_patch = varprecision.utils.getUpperLowerBound(fit_pred,dim);
                if length(setsizes)==1
                    patch([stims;wrev(stims)]',fit_patch,[0.8,0.8,0.8],'LineStyle','None')
                    errorbar(stims,p_right_mean,p_right_sem,'k','LineStyle','None')
                else
                    colorvec = get(gca, 'ColorOrder');
                    colorvec = min(colorvec+.65,1);
                    for jj = 1:length(setsizes)
                        patch([stims;wrev(stims)]',fit_patch(jj,:),colorvec(jj,:),'LineStyle','None')                        
                    end
                    errorbar(repmat(stims,1,length(setsizes)),p_right_mean,p_right_sem,'LineStyle','None')
                end
            end
            xlim([-xLim,xLim])
            text(text_x,0.9,model_name)
            ylim([0,1])
        else
            for jj = 1:length(models)
                if ismember(length(models), [6,8])
                    subplot(2,length(models)/2,jj)
                else
                    subplot(1,length(models),jj)
                end
                hold on
                model = models(jj);
                model_name = varprecision.utils.mapModelName(fetch1(varprecision.Model & model & keys, 'model_name'));
                if length(subjs)==1;
                    if strcmp(type, 'both')
                        fit_pred = fetch1(varprecision.FitPrediction & exp & keys & model,'prediction_plot');
                    elseif strcmp(type, 'bps')
                        fit_pred = fetch1(varprecision.FitPredictionBpsBest & exp & keys & model,'prediction_plot');
                    end
                    plot(stims,p_right,'o')
                    plot(stims,fit_pred)

                else
                    if strcmp(type, 'both')
                        fit_pred = fetchn(varprecision.FitPrediction & exp & keys & model,'prediction_plot');
                    elseif strcmp(type, 'bps')
                        fit_pred = fetchn(varprecision.FitPredictionBpsBest & exp & keys & model,'prediction_plot');
                    end
                    [fit_pred, dim] = varprecision.utils.decell(fit_pred);
                    fit_patch = varprecision.utils.getUpperLowerBound(fit_pred,dim);
                    if length(setsizes)==1
                        patch([stims;wrev(stims)]',fit_patch,[0.5,0.5,0.5],'LineStyle','None')
                        errorbar(stims,p_right_mean,p_right_sem,'k','LineStyle','None')
                    else
                        colorvec = get(gca, 'ColorOrder');
                        colorvec = min(colorvec+.65,1);
                        for kk = 1:length(setsizes)
                            patch([stims;wrev(stims)]',fit_patch(kk,:),colorvec(kk,:),'LineStyle','None')                        
                        end
                        errorbar(repmat(stims,1,length(setsizes)),p_right_mean',p_right_sem','LineStyle','None')
                    end
                end
                xlim([-xLim,xLim]);
                
                text(text_x,0.9,model_name)
                set(gca,'YTick',0:0.2:1)
                if exp.exp_id~=3
                    set(gca,'XTick',-20:10:20);
                else
                    set(gca,'XTick',-20:2.5:20);
                end
                ylim([0,1])
            end
                
        end
        
    end
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(models(1).exp_id) '_psy.eps'])
end


