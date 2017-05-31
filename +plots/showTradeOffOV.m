function showTradeOffOV(varargin)
%SHOWTRADEOFFOV Summary of this function goes here
%   Detailed explanation goes here

key = fetch(varprecision.TradeOffTest & varargin);

[pars_ub, pars_lb, nsteps] = fetch1(varprecision.TradeOffTest & key, 'test_pars_ub', 'test_pars_lb', 'nsteps');
llmat = fetchn(varprecision.TradeOffTestLikelihoodPars & key, 'll');
llmat = -squeeze(reshape(llmat,nsteps));

% llmat = exp(llmat-max(llmat(:)));

fig = Figure(102,'size',[70,40]);

if key.exp_id == 3
    x = linspace(pars_lb(1),pars_ub(1),nsteps(1));
    y = linspace(pars_lb(2),pars_ub(2),nsteps(2));
    imagesc(x, y, llmat');
    set(gca,'Ydir','normal','XTick',0:0.05:0.2, 'YTick',0:0.02:0.1)
    xlabel('precision')
    ylabel('guessing rate')
    
else
    x = linspace(pars_lb(2),pars_ub(2),nsteps(2));
    y = linspace(pars_lb(3),pars_ub(3),nsteps(3));
    imagesc(x, y, llmat')
    set(gca,'Ydir','normal','XTick',0:0.025:0.1, 'YTick',0:0.2:1)
    
    xlabel('tau')
    ylabel('beta')
end
h = colorbar;
ylabel(h, 'Log likelihood','FontSize',8)
fig.cleanup

fig.save(['~/Dropbox/VR/+varprecision/figures/exp' num2str(key.exp_id) '_trade_off'])