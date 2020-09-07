%% calculate cdf of the product of two von mises distributions
% x could be matrix, kappa is a single number, to speed up for the CP case
function y = vmproductcdf_trapz_CP(kappa, tKappa, x, low_bound, up_bound, setsize, nSteps)
%% parameter settings for debugging
% load('x');
% x = x';
% % kappa = 10;
% % % x = pi/4;
% % tKappa = 10; % kappa of the target
% % up_border = pi/2;
% % down_border = 0;
% % trial_num = 1000;
% % setsize = 4;
%% caluclate cdf

% nSteps = 30; 
s = linspace(low_bound, up_bound, nSteps)';

% orginal equation
% pdf = exp(kappa.*cos(2.*(x-s))).* exp(tKappa.*cos(2*s))./4./pi^2./besseli(0,kappa)./besseli(0,tKappa);
x = permute(x, [3,1,2]);
x  = repmat(x, [length(s),1,1]);

% alternative option
x1 = bsxfun(@minus, x,s);
x2 = bsxfun(@plus, kappa*cos(2*x1), tKappa*cos(2*s));
pdf = exp(x2);
%% return the cdf value of certain x and intergral borders
y = squeeze(trapz(s,pdf,1));
if setsize==1
    y = y';
end
