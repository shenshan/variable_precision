function cdf_out = tcdf2(x,mu,lambda,theta)
%TCDF2 computes the cumulative probability of student t distribution
%   function cdf = tcdf2(x,lambda,theta)
step = 0.01;
s = -100:step:100;
pdf = tpdf2(s,mu,lambda,theta);
idx = interp1(s,1:length(s),x,'nearest');
cdf_out = cumsum(pdf)*step;
cdf_out = cdf_out(idx);