
x = -10:0.1:10;
lambda = 0.05;
j = 0.5;
jbar = 0.4; 
tau = 0.2;
R = 10;
y1 = normpdf(x,0,1/sqrt(j))*(1-lambda) + lambda/R;
y2 = tpdf2(x,0,jbar,tau);
y = [y1;y2];

fig = Figure(111,'size',[50,30]);
plot(x,y);
hold on; plot(zeros(1,1000), linspace(0,max(y(:)),1000), '--k');
set(gca,'XTick',0,'XTickLabel','s')
set(gca,'YTick',[])
yLim = get(gca,'YLim');
ylim([yLim(1),yLim(2)*1.2]) 
xlim([-10,10])
xlabel('Measurements');
ylabel('Probability')
fig.cleanup 
fig.save('~/Dropbox/VR/+varprecision/figures/measurement distribution')