
exp = 'exp_id=9';

subjs = fetch(varprecision.Subject & 'subj_type="real"');
records = fetch(varprecision.Recording & exp & subjs);
factor_code = {'Base','G','O','GO','D','GD','DO','GDO','V','GV','OV','GOV','DV','GDV','DOV','GDOV'};

lmeMat = zeros(length(records),length(factor_code));

for ii = 1:length(factor_code);
    model = fetch(varprecision.Model & records & ['factor_code="' factor_code{ii} '"'] & 'model_type="opt"');
    lmeMat(:,ii) = fetchn(varprecision.FitParsEviBpsBestAvg & model,'llmax');
end

[alpha,exp_r,xp,pxp,bor,g] = spm_BMS_fast(lmeMat,[],1,1,1,[])


