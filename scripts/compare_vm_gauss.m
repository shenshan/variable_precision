step = 0.0005;
delta_s_vec = 0:step:pi/2; s_ref_vec = -pi/2:step:pi/2;

[s_ref_grid, delta_s_grid] = meshgrid(s_ref_vec,delta_s_vec);

xt = -60*pi/180; xref = -65*pi/180;

kappa = 10; kappa_s = 10;

sigma = 2/sqrt(kappa);
sigma_s = 2/sqrt(kappa_s);

vmresults = 4*sum(sum(circ_vmpdf(2*(xt-delta_s_grid),2*s_ref_grid,kappa).*circ_vmpdf(2*xref,2*s_ref_grid,kappa).*circ_vmpdf(2*delta_s_grid,0,kappa_s)*step^2))/pi

vmresults2 = 2*sum(circ_vmpdf(2*(xt-delta_s_vec),2*xref,kappa/2).*circ_vmpdf(2*delta_s_vec,0,kappa_s)*step)/pi

gaussresults = sum(normpdf(xt-xref,delta_s_vec,sqrt(2*sigma^2).*normpdf(delta_s_vec,0,sigma_s))*step)/pi