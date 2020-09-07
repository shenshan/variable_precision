%% calculate cdf of the product of two von mises distributions
% kappa, x could be matrices with the same size
function y = vmproductcdf_trapz(kappa, tKappa, x, low_bound, up_bound, nSteps,scale)

if ~exist('scale','var')
    scale=0;
end
%% caluclate cdf
[dim1,dim2] = size(x);
s = linspace(low_bound, up_bound, nSteps);
x = repmat(x, [1,1,length(s)]);
kappa = repmat(kappa, [1,1,length(s)]);
s_epd = permute(s, [3,1,2]);
s_epd = repmat(s_epd, [dim1, dim2, 1]);

if scale
    pdf = exp(bsxfun(@minus,kappa.*cos(2*(x-s_epd)) + tKappa*cos(2*s_epd),scale));
else
    pdf = exp(kappa.*cos(2*(x-s_epd)) + tKappa*cos(2*s_epd));
end

%% return the cdf value of certain x and intergral borders
y = squeeze(trapz(s,pdf,3));
