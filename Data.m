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
            
            if strcmp(type,'real_sub')
                tuple = key; 
                str = regexp(key.subj_initial, '_ss_','split');
                tuple.subj_initial = str{1};
                setsize = str2double(str{2});
                type = 'real';
                [stimuli, response, set_size] = varprecision.utils.readData(tuple,type);
                stimuli = stimuli(set_size==setsize,:);
                key.stimuli = stimuli(:,1:setsize);
                key.response = response(set_size==setsize);
                key.set_size = set_size(set_size==setsize);
            else
                [key.stimuli, key.response, key.set_size] = varprecision.utils.readData(key,type);
            end                
 
            key.ntrials = length(key.response);
			self.insert(key)
		end
	end

end