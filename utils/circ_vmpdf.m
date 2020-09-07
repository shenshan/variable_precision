function probability = circ_vmpdf(x,mu,kappa)

probability = exp(kappa.*cos(x-mu))./2/pi/besseli(0,kappa);