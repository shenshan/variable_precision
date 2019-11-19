s = linspace(-5,5,100);
guess = 0.05;

j = 0.5;
jbar = 0.4;
tau = 0.2;
p_right_FPG = (1-guess)*normcdf(s,0,1/sqrt(j)) + 0.5*guess;
p_right_VP = tcdf2(s,0,jbar,tau);

fig = Figure(112,'size',[50,35]);

plot(s,p_right_FPG,s,p_right_VP)
set(gca,'XTick',-5:1:5,'YTick',0:0.2:1);
xlabel('Stimulus/deg')
ylabel('Proportion of reporting "right"')

fig.cleanup
fig.save('~/Dropbox/VR/+varprecision/figures/psychCurves_exp')