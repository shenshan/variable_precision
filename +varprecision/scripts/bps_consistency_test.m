parsMat = zeros(10,3);
lmlMat = zeros(10,1);

for ii = 1:length(lmlMat)
    [parsMat(ii,:),lmlMat(ii)] = bps(@(params)varprecision.decisionrule_bps.exp1(params,'VP'),[0.5,0.05,0.02],[0.3,0.0001,0.0001],[0.7,1,0.8]);
end