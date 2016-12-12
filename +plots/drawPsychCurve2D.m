function drawPsychCurve2D(type, varargin)

% works for exp6 for now

assert(ismember(type, {'data','both'}), 'please select one of the following: data, both:')
subjs = fetch(varprecision.Subject & 'subj_type="real"');

res_data = varprecision.utils.parseVarargin('subj',varargin);
res_exp = varprecision.utils.parseVarargin('exp',varargin);
res_model = varprecision.utils.parseVarargin('model',varargin);
keys = fetch(varprecision.DataStats2D & res_data & res_exp & subjs);


if length(keys)==1
    [p_right_mean,stims] = fetch1(varprecision.DataStats2D & keys & subjs,'p_right','stims');
    
else
    [p_right,stims] = fetchn(varprecision.DataStats2D & keys & subjs,'p_right','stims');
    stims = [stims{1}];
    [p_right,dim,len] = varprecision.utils.decell(p_right);
    p_right_mean = mean(p_right,dim);
    p_right_sem = std(p_right,[],dim)./sqrt(len);
end

xLim = max(stims)*1.1;
text_x = -max(stims)*0.8;

if strcmp(type,'data')   
    fig = Figure(102,'size',[80,50]);
    plot(stims,p_right_mean, 'o'); hold on
    
    if length(keys)>1
        colorvec = get(gca,'colororder');
        for ii = 1:size(p_right_mean,2)
            errorbar(stims,p_right_mean(:,ii),p_right_sem(:,ii),'Color',colorvec(ii,:),'LineStyle','None')
        end
    end
    legend('dist<-5','-5<dist<5','dist>5','Location','NorthWest')
    ylim([0,1])
    fig.cleanup
else
    models = fetch(varprecision.Model & res_exp & res_model);
    if length(models) == 1
        fig = Figure(102,'size',[80,50]);
    elseif length(models)==4
        fig = Figure(102,'size',[100,60]);
    elseif length(models)==6
        fig = Figure(102,'size',[140,60]);
    elseif length(models)==8
        fig = Figure(102,'size',[160,60]);
    else
        fig = Figure(102,'size',[30*length(models)+10,30]);
    end
    
    if length(models) == 1
        if length(keys) == 1 
            fit_pred = fetch1(varprecision.FitPredictionBpsBest2D & varargin,'prediction_plot_2d');
            plot(stims, p_right_mean,'o'); hold on
            plot(stims, fit_pred);
        else
            
            fit_pred = fetchn(varprecision.FitPredictionBpsBest2D & varargin,'prediction_plot_2d');
            [fit_pred, dim] = varprecision.utils.decell(fit_pred);
            fit_patch = varprecision.utils.getUpperLowerBound(fit_pred,dim,2);
            colorvec = get(gca, 'ColorOrder');
            colorvec = min(colorvec+.65,1);
            for jj = 1:size(fit_pred,2)
                patch([stims;wrev(stims)]',fit_patch(jj,:)',colorvec(jj,:),'LineStyle','None')                        
            end
            hold on
            errorbar(repmat(stims,1,size(fit_pred,2)),p_right_mean,p_right_sem,'LineStyle','None')
        end        
    else
        for jj = 1:length(models)
            
            if ismember(length(models), [4,6,8])
                subplot(2,length(models)/2,jj)
            else
                subplot(1,length(models),jj)
            end
            hold on
            model = models(jj);
            model_name = fetch1(varprecision.Model & res_exp & model, 'model_name');
            if length(keys)==1;

                fit_pred = fetch1(varprecision.FitPredictionBpsBest2D & keys & model,'prediction_plot_2d');
                
                plot(stims,p_right_mean,'o')
                plot(stims,fit_pred)

            else
                fit_pred = fetchn(varprecision.FitPredictionBpsBest2D & keys & model,'prediction_plot_2d');
                [fit_pred, dim] = varprecision.utils.decell(fit_pred);
                fit_patch = varprecision.utils.getUpperLowerBound(fit_pred,dim,2);
                colorvec = get(gca, 'ColorOrder');
                colorvec = min(colorvec+.65,1);
                for kk = 1:size(fit_pred,2)
                    patch([stims;wrev(stims)]',fit_patch(kk,:)',colorvec(kk,:),'LineStyle','None')                        
                end
                errorbar(repmat(stims,1,size(fit_pred,2)),p_right_mean,p_right_sem,'LineStyle','None')
            
            end
            xlim([-xLim,xLim])
            text(text_x,0.9,model_name)
            set(gca,'YTick',0:0.2:1)
            set(gca,'XTick',-20:10:20);
            ylim([0,1])
        end
    end
        
    
    legend('dist<-5','-5<dist<5','dist>5','Location','NorthWest')
    ylim([0,1])
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(models(1).exp_id) '_psy_2d.eps'])
end

