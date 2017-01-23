%{
varprecision.FakeDataParams (computed) # table that saves the parameters to generate fake data
-> varprecision.Recording
---
p_right                     : double                        # prior
lambda                      : blob                          # lambda, a vector or scalar, depends on different experiments
theta                       : double                        # scale factor of gamma distribution to discribe precision
guess                       : double                        # lapse rate
beta=null                   : double                        # amplitude of orientation dependence
%}

classdef FakeDataParams < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.Recording & (varprecision.Subject & 'subj_type="fake"')
    end
    
    methods(Access=protected)

		function makeTuples(self,key)
            
            [mode, model_gene] = fetch1(varprecision.Subject & key, 'fake_param_method','model_gene');
            
            pars = varprecision.utils.generateFakeParams(mode,['exp_id="' num2str(key.exp_id) '"'],['model_name="' model_gene '"']);
            
            key.p_right = pars.p_right;
            key.lambda = pars.lambda;
            
            if isfield(pars,'theta')
                key.theta = pars.theta;
            end
            if isfield(pars,'guess')
                key.guess = pars.guess;
            end
            if isfield(pars,'beta')
                key.beta = pars.beta;
            end
            
            self.insert(key)
            
        end
	end

end

