x = -5:0.01:10;
lambda1 = 0.75;
theta = 0.5;
y = gampdf(x,lambda1/theta,theta);
theta = 0.00000001;
y2 = gampdf(x,lambda1/theta,theta);
fig = Figure(110,'size',[50,30]);
plot(x,y); hold on
plot(x,y2, 'Color',[0,0.5,0]);
xlim([0,3]);
ylim([0,1.5]);
xlabel('Precision');
ylabel('Probability');
set(gca,'YTick',[])
fig.cleanup
fig.save('~/Dropbox/VR/+varprecision/figures/precision_distribution')

fig2 = Figure(120,'size',[50,30]);

sigma1 = 1/sqrt(lambda1);
beta = 0.5;
x = -90:0.1:90;
y = 1./(sigma1*(1+beta*abs(sin(x*pi/180*2)))).^2;
beta = 0;
y2 = 1./(sigma1*(1+beta*abs(sin(x*pi/180*2)))).^2;

plot(x,y,'r',x,y2,'k');
xlabel('Orientation/deg')
ylabel('Precision for OF model')
set(gca,'YTick',[],'xTick',-90:45:90)

fig2.cleanup
fig2.save('~/Dropbox/VR/+varprecision/figures/precision_distribution_OF.eps')