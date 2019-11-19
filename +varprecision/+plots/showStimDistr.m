function showStimDistr(exp_id, save)
%SHOWSTIMDISTR shows the stimulus distribution for didactic usage
%  exp_id is the final exp index in the paper

if ~exist('save','var')
    save = 0;
end
switch exp_id
    
    case {1,3}
        stimuli = linspace(-15,15,19);
    case 4
        stimuli = linspace(-5,5,19);
    case {5,6}
        stimuli = linspace(-20,20,19);
    case {2,7,8,9,10}
        stimuli = linspace(-90,90,200);
        
end

if exp_id == 2
    fig = Figure(102,'size',[110,30]); hold on
else
    fig = Figure(102,'size',[60,30]); hold on
end

switch exp_id
    
    case {1,3,4,5,6}
        
        for ii = 1:length(stimuli)
            plot([stimuli(ii),stimuli(ii)],[0,1/19], 'k');
        end
        xlim([max(min(stimuli)*1.2,-90), min(max(stimuli)*1.2,90)])
        
        if exp_id == 4
            set(gca,'XTick',min(stimuli):2.5:max(stimuli))
        else
            set(gca,'XTick',min(stimuli):5:max(stimuli))
        end
        
        xlabel('Target orientation ()')
        ylabel('Probability')
        
        if ismember(exp_id, [5,6])
            plot([0,0],[0,0.1],'k--')
            set(gca,'XTick',-20:10:20)
            legend('Target','Distractor','Location', 'Northwest')
            xlabel('Orientation ()')
        end
        ylim([0,1])
        
    case 2
        subplot 121
        plot([-90,90],[1/180,1/180],'k')
        xlim([-90,90])
        ylim([0,0.1])
        set(gca,'XTick', -90:30:90,'YTick',0:0.02:0.1)
        ylabel('Probability density')
        xlabel('Reference orientation ()')
        subplot 122
        kappa0 = 10;
        prob_target = exp(kappa0*cos(stimuli*pi/90))/2/pi/besseli0_fast(kappa0)*pi/90;
        plot(stimuli,prob_target,'k'); hold on
        xlim([-50,50])
        set(gca,'XTick',-45:15:45)
        ylabel('Probability density')
        xlabel('Target - reference')
    case 7
        kappa0 = 10;
        prob = exp(kappa0*cos(stimuli*pi/90))/2/pi/besseli0_fast(kappa0)*pi/90;
        plot(stimuli,prob,'k')
        xlim([-50,50])
        set(gca,'Xtick',-45:15:45)
        ylabel('Probability density')
        xlabel('Target or distractor orientation ()')
    case 8
        kappa0 = 32.8;
        prob = exp(kappa0*cos(stimuli*pi/90))/2/pi/besseli0_fast(kappa0)*pi/90;
        plot(stimuli,prob,'k--')
        set(gca,'Xtick',-45:15:45)
        xlim([-50,50])
        ylabel('Probability density')
        xlabel('Orientation ()')
        plot([0,0],[0,0.1],'k')
    case {9,10}
        kappa0 = 10;
        prob = exp(kappa0*cos(stimuli*pi/90))/2/pi/besseli0_fast(kappa0)*pi/90;
        plot(stimuli,prob,'k')
        set(gca,'Xtick',-90:30:90)
        ylabel('Probability density')
        xlabel('Orientation ()')
        plot([-90,90],[1/180,1/180],'k--')
        xlim([-90,90])
    case 11
        plot([-90,90],[1/180,1/180],'k--')
        plot([0,0],[0,0.1],'k')
        set(gca,'XTick',-90:30:90)
        xlim([-90,90])
        ylabel('Probability density')
        xlabel('Orientation ()')
end

if ismember(exp_id, [1,3,4,5,6])
    ylim([0,1])
    set(gca,'YTick',0:0.2:1)
    
else
    ylim([0,0.1])
    set(gca,'YTick',0:0.02:0.1)
end

fig.cleanup

if save
    fig.save(['~/Dropbox/VR/+varprecision/figures/exp_' num2str(exp_id) '_stim_dist'])
end
        
        