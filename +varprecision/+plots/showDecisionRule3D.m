function showDecisionRule3D
% show decision boundary of the decision rule of Exp6/7 in a 3D space
x11 = -90:5:90;
x22 = -90:5:90;
x33 = -90:5:90;
x1 = x11*pi/180;
x2 = x22*pi/180;
x3 = x33*pi/180;
nTrials = length(x1)*length(x2)*length(x3);
c1 = ones(1,nTrials);
c2 = ones(nTrials,3);
xMat = ones(3,length(x1),length(x2),length(x3));
for ii = 1:length(x1)
    for jj = 1:length(x2)
        for kk = 1:length(x3)
            xMat(:,ii,jj,kk)=[x1(ii),x2(jj),x3(kk)];                        
        end
    end
end

xMat2 = reshape(xMat,3,nTrials);

pars= struct('pre',0,'model_name','CP','lambda',0.04*180^2/pi^2/4,'rule','opt','p_right',0.5,'factor_code','Base');
[~,~,obs_response] = varprecision.decisionrule.exp6(xMat2,pars);

c1(obs_response>0) = 0;
c2(obs_response>0,:) = repmat([0.6,0.6,1],sum(obs_response>0),1);

c1 = reshape(c1,length(x1),length(x2),length(x3));
% c2 = reshape(c2,length(x1),length(x2),length(x3),3);
save('opt_structure','c1','c2','x1','x2','x3');
fig = Figure(101,'size',[100,100]);
c1 = smooth3(c1,'box',3);
p = patch(isosurface(x11,x22,x33,c1,0),'FaceVertexCData',[1 0 0],'FaceColor','r','EdgeColor','none');
isonormals(x11,x22,x33,c1,p)
daspect([1,1,1])
view(-28,55); axis tight
camlight 
lighting gouraud
grid on
xlabel('x1'); ylabel('x2'); zlabel('x3')
fig.cleanup
fig.save('opt_rule_boundary.eps')