function showParsRegression(mode, varargin)
%SHOWPARSREGRESSION shows true parameters versus the fit parameters 
%   function showParsRegression(mode,varargin)
%   mode specifies the method that was used to generate fake data parameters.
%   varargin includes restriction of experiments and model

subjs = fetch(varprecision.Subject & 'subj_type="fake"' & ['fake_param_method="' mode '"']);
model_res = varprecision.utils.parseVarargin('model',varargin);
exp_res = varprecision.utils.parseVarargin('exp',varargin);
exps = fetch(varprecision.Experiment & exp_res);


wid = 30;
height = 40;
edge = 10;

for iexp = exps'
    
    models = fetch(varprecision.Model & iexp & model_res);
    setsizes = fetch1(varprecision.Experiment & iexp, 'setsize');
    nlambda = length(setsizes);
    
    for imodel = models'
        % fetch corresponding tables for real parameters and fit parameters
        subj = fetch(varprecision.Subject & subjs & ['model_gene="' imodel.model_name '"']);
        [p_rightMat,lambdaMat,thetaMat,betaMat,guessMat,subj_initial] = fetchn(varprecision.FakeDataParams & imodel & subj & iexp, 'p_right','lambda','theta','beta','guess','subj_initial');
        [p_rightMat_fit,lambdaMat_fit,betaMat_fit,thetaMat_fit,guessMat_fit,subj_initial_fit] = fetchn(varprecision.FitParsEviBpsBest & imodel & subj & iexp, 'p_right_hat','lambda_hat','theta_hat','beta_hat','guess_hat','subj_initial');
        
        p_right_real = varprecision.utils.decell(p_rightMat);
        lambda_real = squeeze(varprecision.utils.decell(lambdaMat));
        
        p_right_fit = varprecision.utils.decell(p_rightMat_fit);
        lambda_fit = squeeze(varprecision.utils.decell(lambdaMat_fit));
        if iscolumn(lambda_real)
            lambda_real = lambda_real';
            lambda_fit = lambda_fit';
        end
        
        switch imodel.model_name
            case 'CP'
                fig = Figure(101,'size',[wid*(nlambda+1)+edge,height]); hold on
                subplot(1,nlambda+1,1)
                scatter(p_right_real,p_right_fit,'o')
                refline(1)
                for ii = 1:nlambda
                    subplot(1,nlambda+1,ii+1)
                    scatter(lambda_real(ii,:),lambda_fit(ii,:),'o')
                    refline(1)
                end
            case 'CPG'
                guess_real = varprecision.utils.decell(guessMat);
                guess_fit = varprecision.utils.decell(guessMat_fit);
                fig = Figure(102,'size',[wid*(nlambda+2)+edge,height]); hold on
                subplot(1,nlambda+2,1)
                scatter(p_right_real,p_right_fit,'o')
                refline(1)
                for ii = 1:nlambda
                    subplot(1,nlambda+2,ii+1)
                    scatter(lambda_real(ii,:),lambda_fit(ii,:),'o')
                    refline(1)
                end
                subplot(1,nlambda+2,nlambda+2)
                scatter(guess_real,guess_fit,'o')
                refline(1)
            case 'VP'
                theta_real = varprecision.utils.decell(thetaMat);
                theta_fit = varprecision.utils.decell(thetaMat_fit);
                fig = Figure(103,'size',[wid*(nlambda+2)+edge,height]); hold on
                subplot(1,nlambda+2,1)
                scatter(p_right_real,p_right_fit,'o')
                refline(1)
                for ii = 1:nlambda
                    subplot(1,nlambda+2,ii+1)
                    scatter(lambda_real(ii,:),lambda_fit(ii,:),'o')
                    refline(1)
                end
                subplot(1,nlambda+2,nlambda+2)
                scatter(theta_real,theta_fit,'o')
                refline(1)
            case 'VPG'
                theta_real = varprecision.utils.decell(thetaMat);
                theta_fit = varprecision.utils.decell(thetaMat_fit);
                guess_real = varprecision.utils.decell(guessMat);
                guess_fit = varprecision.utils.decell(guessMat_fit);
                fig = Figure(104,'size',[wid*(nlambda+3)+edge,height]); hold on
                subplot(1,nlambda+3,1)
                scatter(p_right_real,p_right_fit,'o')
                refline(1)
                for ii = 1:nlambda
                    subplot(1,nlambda+3,ii+1)
                    scatter(lambda_real(ii,:),lambda_fit(ii,:),'o')
                    refline(1)
                end
                subplot(1,nlambda+3,nlambda+2)
                scatter(theta_real,theta_fit,'o')
                refline(1)
                subplot(1,nlambda+3,nlambda+3)
                scatter(guess_real,guess_fit,'o')
                refline(1)
            case 'OPVPG'
                theta_real = varprecision.utils.decell(thetaMat);
                theta_fit = varprecision.utils.decell(thetaMat_fit);
                beta_real = varprecision.utils.decell(betaMat);
                beta_fit = varprecision.utils.decell(betaMat_fit);
                guess_real = varprecision.utils.decell(guessMat);
                guess_fit = varprecision.utils.decell(guessMat_fit);
                fig = Figure(104,'size',[wid*(nlambda+3)+edge,height]); hold on
                subplot(1,nlambda+4,1)
                scatter(p_right_real,p_right_fit,'o')
                refline(1)
                for ii = 1:nlambda
                    subplot(1,nlambda+4,ii+1)
                    scatter(lambda_real(ii,:),lambda_fit(ii,:),'o')
                    refline(1)
                end
                subplot(1,nlambda+4,nlambda+2)
                scatter(theta_real,theta_fit,'o')
                refline(1)
                subplot(1,nlambda+4,nlambda+3)
                scatter(beta_real,beta_fit,'o')
                refline(1)
                subplot(1,nlambda+4,nlambda+4)
                scatter(guess_real,guess_fit,'o')
                refline(1)
        end
        fig.cleanup
    end
    
end



