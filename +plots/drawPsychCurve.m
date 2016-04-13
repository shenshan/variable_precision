function drawPsychCurve(type,varargin)
%DRAWPSYCHCURVE Draw psychometric curve for a given model
%   type specifies data, model or both

assert(ismember(type,{'data','both'}),'Invalid input for type, please enter one of the three: data or both.')

switch type
    case 'data'
        keys = fetch(varprecision.DataStats & varargin);
    case 'both'
        keys = fetch(varprecision.FitPrediction & varargin);
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
    
    fig = Figure(102,'size',[90,60]);
    hold on
    xLim = max(stims)*1.2;
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
    elseif strcmp(type,'both')
        if length(models)==1
            model_name = fetch1(varprecision.Model & keys);
            if length(subjs)==1
                fit_pred = fetch1(varprecision.FitPrediction & exp & keys,'prediction_plot');
                plot(stims,p_right,'o')
                plot(stims,fit_pred)
                
            else 
                fit_pred = fetchn(varprecision.FitPrediction & exp & keys,'prediction_plot');
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
                    errorbar(repmat(stims,1,length(setsizes)),p_right_mean',p_right_sem','LineStyle','None')
                end
            end
            xlim([-xLim,xLim])
            text(text_x,0.9,model_name)
        else
            for jj = 1:length(models)
                if length(models)==4
                    subplot(2,2,jj)
                else
                    subplot(1,length(models),jj)
                end
                hold on
                model = models(jj);
                model_name = fetch1(varprecision.Model & model & keys, 'model_name');
                if length(subjs)==1;
                    fit_pred = fetch1(varprecision.FitPrediction & exp & keys & model,'prediction_plot');
                    plot(stims,p_right,'o')
                    plot(stims,fit_pred)

                else
                    fit_pred = fetchn(varprecision.FitPrediction & exp & keys & models,'prediction_plot');
                    [fit_pred, dim] = varprecision.utils.decell(fit_pred);
                    fit_patch = varprecision.utils.getUpperLowerBound(fit_pred,dim);
                    if length(setsizes)==1
                        patch([stims;wrev(stims)]',fit_patch,[0.8,0.8,0.8],'LineStyle','None')
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
            end
                
        end
    end
    fig.cleanup
end


