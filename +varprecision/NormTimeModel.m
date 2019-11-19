%{
varprecision.NormTimeModel (computed) # compute normalized running time 
-> varprecision.NoiseMeasure
-----
norm_run_time: double   # running time normalized to that of 1000 trials on the same core.
%}

classdef NormTimeModel < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.NoiseMeasure
    end
    methods(Access=protected)

		function makeTuples(self, key)
            
            [run_host,trial_num_sim,run_time]= fetch1(varprecision.NoiseMeasure & key, 'run_host','trial_num_sim','run_time');
            key_rel = (varprecision.Data & key);
            
            key_base = fetch(varprecision.NoiseMeasure & key_rel & ['run_host="' run_host '"'] & ['trial_num_sim=' num2str(trial_num_sim)] & 'model_name="CP"');
            
            if isempty(key_base)
                return
            end
            
            base_time = fetch1(varprecision.NoiseMeasure & key_base,'run_time');
            key.norm_run_time = run_time/base_time;
     
			self.insert(key)
		end
	end

end