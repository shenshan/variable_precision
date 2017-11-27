function drawPsychCurveIndAllModels(varargin)
%DRAWPSYCHCURVE Draw psychometric curve for a given model
%   type specifies data, model or both

subjs = fetch(varprecision.Subject & 'subj_type="real"');
keys = fetch(varprecision.FitPredictionBpsBestAvg & subjs & varargin);
exps = fetch(varprecision.Experiment & keys);

for ii = 1:length(exps)
    
    exp = exps(ii);

    models = {'CP','VP','CPG','VPG','OP','OPVP','OPG','OPVPG','CPN','VPN','CPGN','VPGN','OPN','OPVPN','OPGN','OPVPGN'};
    model_names = {'Base','V','G','GV','O','OV','GO','GOV','D','DV','GD','GDV','OD','ODV','GOD','GODV'};
    setsizes = fetch1(varprecision.Experiment & exp & keys,'setsize');
      
    [p_right,stims] = fetchn(varprecision.DataStats & exp & keys, 'p_right','stims');
    stims = [stims{1}];
    [p_right,dim,len] = varprecision.utils.decell(p_right);
    p_right_mean = mean(p_right,dim);
    p_right_sem = std(p_right,[],dim)./sqrt(len);
    
    fig = Figure(102,'size',[48*4+3,27*4]);

    hold on
    xLim = max(stims)*1.1;
    text_x = -max(stims)*0.8;
    
    for jj = 1:length(models)
        
        subplot(4,4,jj)
        
        hold on
        model = fetch(varprecision.Model & exp & ['model_name="' models{jj} '"']);
        
        fit_pred = fetchn(varprecision.FitPredictionBpsBestAvg & exp & keys & model,'prediction_plot');
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

        xlim([-xLim,xLim]);
        model_name = model_names{jj};
        text(text_x,0.9,model_name)
        set(gca,'YTick',0:0.2:1)
        if exp.exp_id~=3
            set(gca,'XTick',-20:10:20);
        else
            set(gca,'XTick',-20:2.5:20);
        end
        ylim([0,1])
    end

    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(exp.exp_id) '_psy_all.eps'])
end


