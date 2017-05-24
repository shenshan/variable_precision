function showTradeOffLLmarginals(type,exp_id,margin_dim,varargin)
%SHOWTRADEOFFLLMARGINALS shows marginals for a certain parameter
%   For the paper, call the function as following:
%   Trade-off between precision and guessing:
%   varprecision.plots.showTradeOffLLmarginals('sum',3,2);
%   Trade-off between factors O and V:
%   varprecision.plots.showTradeOffLLmargins('sum',6,3)

[pars_ub,pars_lb,nsteps] = fetch1(varprecision.TradeOffTest & sprintf('exp_id=%d',exp_id) & varargin,'test_pars_ub','test_pars_lb','nsteps');
parvec = linspace(pars_lb(margin_dim),pars_ub(margin_dim),nsteps(margin_dim));

if strcmpi(type,'sum')
    llvec = fetch1(varprecision.TradeOffMarginals & sprintf('exp_id=%d',exp_id) & sprintf('margin_dim=%d',margin_dim) & varargin,'ll_sum');
elseif strcmpi(type,'max')
    llvec = fetch1(varprecision.TradeOffMarginals & sprintf('exp_id=%d',exp_id) & sprintf('margin_dim=%d',margin_dim) & varargin,'ll_max');
end

fig = Figure(101,'size',[50,30]);

plot(parvec,llvec,'k')
ylabel('Marginal log likelihood')

if exp_id==3
    xlabel('guessing rate')
elseif exp_id==6
    xlabel('beta')
end

fig.cleanup

