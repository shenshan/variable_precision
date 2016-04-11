%{
varprecision.PrecomputedTable (computed) # experiment 1 to 5, prediction table could be precomputed
-> varprecision.ParameterSet
-----
trial_num_sim     : int         # number of trials for simulation
prediction_table  : longblob    # table size would be length(setsize)xlength(stimuli)xlength(pars)
stims_unique      : blob        # unique stimuli for exp 1-5
%}

classdef PrecomputedTable < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.ParameterSet & 'exp_id<6'
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            % load data to get stimuli and set sizes
            keys = fetch(varprecision.Data & key);
            stimuli = fetch1(varprecision.Data & keys(1), 'stimuli');
            stimuli = unique(stimuli(:,1));
            [setsizes,sigma_s] = fetch1(varprecision.Experiment & key, 'setsize','sigma_s');
            
            % get the parameters
            pars = fetch(varprecision.ParameterSet & key, '*');
            pars.pre = 1; % aims to compute a pretable
            pars.setsizes = setsizes;
            pars.sigma_s = sigma_s;
            key.trial_num_sim = 1000;
            pars.trial_num_sim = 1000;
            key.prediction_table = varprecision.utils.computePreTable(pars,stimuli);
            key.stims_unique = stimuli;          
			self.insert(key)
		end
	end

end