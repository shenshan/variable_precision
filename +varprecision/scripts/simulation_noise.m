LLmat = zeros(1,50);

for ii = 1:length(LLmat)
    LL = varprecision.decisionrule_bps.exp1([0.5,0.05,0.02],'VP')
    LLmat(ii) = LL;
end

mean(LLmat)
std(LLmat)