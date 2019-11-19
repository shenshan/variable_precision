subjs = fetch(varprecision.Subject & 'model_gene="OPVPG"');

records = fetch(varprecision.Recording & subjs & 'exp_id=11');

[stimuli,response,set_size] = fetch1(varprecision.Data & 'subj_initial="DKS"' & 'exp_id=11','stimuli','response','set_size');
stimuli_rad = stimuli*pi/180;

setsizes = unique(set_size);

[jmap,kmap] = fetch1(varprecision.JbarKappaMap & 'jkmap_id=2','jmap','kmap');

for ii = 1:length(records)
    
    pars_ref = fetch(varprecision.FakeDataParams & records(ii),'*');
    
    response = zeros(size(response));
    
    for jj = 1:length(setsizes)
        idx = set_size==setsizes(jj);
        pars = pars_ref;
        pars.lambda = pars_ref.lambda(jj);
        stimuli_sub = stimuli_rad(idx,1:setsizes(jj));
        
        sigma_baseline = 1/sqrt(pars.lambda);
        sigma = sigma_baseline * (1 + pars.beta*abs(sin(2*stimuli_sub)));
        pars.lambdaMat = 1./sigma.^2;
        pars.lambdaMat = gamrnd(pars.lambdaMat/pars.theta, pars.theta)*180^2/pi^2/4;
        pars.lambdaMat = varprecision.utils.mapJK(pars.lambdaMat,jmap,kmap);
        pars.lambdaMat = pars.lambdaMat';
        xMat = stimuli_sub' + circ_vmrnd(0,pars.lambdaMat)/2;
        pars.pre = 0;
        pars.model_name = 'OPVPG';
        [~,response_sub] = varprecision.decisionrule.exp11(xMat,pars);
        response(idx) = response_sub;
    end
    idx_guess = rand(size(response))<pars.guess;
    response_guess = response(idx_guess);
    response(idx_guess) = randi(2,size(response_guess))-1;
    datamatrix = [stimuli, response, set_size];
    save(['~/Dropbox/VR/VP_data/Exp11_fake/' records(ii).subj_initial '.mat'],'datamatrix');
end