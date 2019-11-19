sL = linspace(-90,90,1000);
xL = 8;
xR = 13;
JL = 0.1;
JR = 0.1;
Js = 1/9.06^2;

nomi = sum(normpdf(xL,sL,1/sqrt(JL)).*normpdf(xR,sL,1/sqrt(JR*Js/(JR+Js))).*normcdf(sL,(xR*JR+sL*Js)/(JR+Js),1/sqrt(JR+Js)));

denomi = sum(normpdf(xL,sL,1/sqrt(JL)).*normpdf(xR,sL,1/sqrt(JR*Js/(JR+Js))).*(1-normcdf(sL,(xR*JR+sL*Js)/(JR+Js),1/sqrt(JR+Js))));


d = nomi/denomi


Jc = 1/(1/JL+1/JR);
nomi2 = 1+erf((xL-xR)*Jc/sqrt(2*(Jc+Js)));
denomi2 = 1-erf((xL-xR)*Jc/sqrt(2*(Jc+Js)));

d2 = nomi2/denomi2
