function showParsRegression(mode, varargin)
%SHOWPARSREGRESSION shows true parameters versus the fit parameters 
%   function showParsRegression(mode,varargin)
%   mode specifies the method that was used to generate fake data parameters.
%   varargin includes restriction of experiments and model

subjs = fetch(varprecision.Subject & 'subj_type="fake"' & ['fake_param_method="' mode '"']);
key_res = fetch(varprecision.FakeDataParams & varargin);
exps = fetch(varprecision.Experiment & key_res);


wid = 30;
height = 40;
edge = 10;

for iexp = exps'
    
    models = fetch(varprecision.Model & iexp & key_res);
    setsizes = fetch1(varprecision.Experiment & iexp, 'setsize');
    nlambda = length(setsizes);
    
    for imodel = models'
        % fetch corresponding tables for real parameters and fit parameters
        subj = fetch(varprecision.Subject & subjs & ['model_name="' imodel.model_name '"']);
        [p_rightMat,lambdaMat,thetaMat,guessMat] = fetchn(varprecision.FakeDataParams & imodel & subj & key_res, 'p_right','lambda','theta','guess');
        [p_rightMat_fit,lambdaMat_fit,thetaMat_fit,guessMat_fit] = fetchn(varprecision.FitParametersEvidence & imodel & subj & key_res, 'p_right_hat','lambda_hat','theta_hat','guess_hat');
        
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
        end
        fig.cleanup
    end
    
end



