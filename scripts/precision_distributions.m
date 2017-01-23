x = -5:0.01:10;
lambda1 = 0.75;
theta = 0.5;
y = gampdf(x,lambda1/theta,theta);
y2 = normpdf(x,0,.00001)/50000;
y3 = normpdf(x,1,.00001)/15000;
fig = Figure(110,'size',[50,30]);
plot(x,y,x,y2); hold on
plot(x,y3, 'Color',[0,0.5,0]);
xlim([-1,3]);
% ylim([0,0.04]);
xlabel('Precision');
ylabel('Probability');
set(gca,'XTick',[],'YTick',[])
legend('CV model', 'CFG model');
fig.cleanup
fig.save('~/Dropbox/VR/+varprecision/figures/precision_distribution')

fig2 = Figure(120,'size',[50,30]);

sigma1 = 1/sqrt(lambda1);
beta = 0.5;
x = -90:0.1:90;
y = 1./(sigma1*(1+beta*abs(sin(x*pi/180*2)))).^2;

plot(x,y,'r');
xlabel('Orientation/deg')
ylabel('Precision for OF model')
set(gca,'YTick',[],'xTick',-90:45:90)

fig2.cleanup
fig2.save('~/Dropbox/VR/+varprecision/figures/precision_distribution_OF.eps')