%{
varprecision.Data (imported) # stimulus and response of each subject and experiment 
-> varprecision.Recording
-----
ntrials    : smallint       # number of trials
stimuli    : longblob  # stimuli of all trials, in degs, size nTrials x max(set_size) for exp 5,7. first column is always the target
response   : longblob  # response of all trials, size nTrials x 1
set_size   : longblob  # number of items for each trial, size nTrials x 1
%}

classdef Data < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Recording
    end
    
	methods(Access=protected)

		function makeTuples(self, key)
            type = fetch1(varprecision.Subject & key, 'subj_type');
            [key.stimuli, key.response, key.set_size] = varprecision.utils.readData(key,type);
            key.ntrials = length(key.response);
			self.insert(key)
		end
	end

end