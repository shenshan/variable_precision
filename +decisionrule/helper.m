sL = linspace(-90,90,100);
xL = -30;
xR = -25;
JL = 0.1;
JR = 0.1;
Js = 1/9^2;

nomi = sum(normpdf(xL,sL,1/sqrt(JL)).*normpdf(xR,sL,1/sqrt(JR*Js/(JR+Js))).*(1-normcdf(sL,(xR*JR+sL*Js)/(JR+Js),1/sqrt(JR+Js))));

denomi = sum(normpdf(xL,sL,1/sqrt(JL)).*normpdf(xR,sL,1/sqrt(JR*Js/(JR+Js))).*normcdf(sL,(xR*JR+sL*Js)/(JR+Js),1/sqrt(JR+Js)));


d = nomi/denomi;