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
legend('VP model', 'FPG model');
fig.cleanup
fig.save('~/Dropbox/VR/+varprecision/figures/precision_distribution')