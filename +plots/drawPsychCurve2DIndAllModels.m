function drawPsychCurve2DIndAllModels(varargin)
% draw psychometric curves for all models Exp 6,7,9

subjs = fetch(varprecision.Subject & 'subj_type="real"');

exp = varprecision.utils.parseVarargin('exp',varargin);
keys = fetch(varprecision.DataStats2D & exp & subjs);

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

models = {'CP','VP','CPG','VPG','OP','OPVP','OPG','OPVPG','CPN','VPN','CPGN','VPGN','OPN','OPVPN','OPGN','OPVPGN'};
model_names = {'Base','V','G','GV','O','OV','GO','GOV','D','DV','GD','GDV','OD','ODV','GOD','GODV'};

fig = Figure(102,'size',[48*4+3,30*4]);

for jj = 1:length(models)
    
    subplot(4,4,jj)
    hold on
    model = fetch(varprecision.Model & exp & ['model_name="' models{jj} '"']);
    model_name = model_names{jj};
    if length(keys)==1;

        fit_pred = fetch1(varprecision.FitPredictionBpsBest2DAvg & keys & model,'prediction_plot_2d');

        plot(stims,p_right_mean,'o')
        plot(stims,fit_pred)

    else
        fit_pred = fetchn(varprecision.FitPredictionBpsBest2DAvg & keys & model,'prediction_plot_2d');
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

    
%     legend('dist<-5','-5<dist<5','dist>5','Location','NorthWest')
    ylim([0,1])
    fig.cleanup
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(model.exp_id) '_psy_2d_all.eps'])
end

