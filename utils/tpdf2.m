function pdf = tpdf2(x,mu,lambda,theta)
%TPDF2 computes the density function of student t distribution
%   function y = tpdf2(x,lambda,theta)

k = lambda/theta;
pdf = gamma(k+0.5)/gamma(k)*sqrt(lambda/(pi*2*k))*(1+lambda*(x-mu).^2/2/k).^(-k-1/2);


