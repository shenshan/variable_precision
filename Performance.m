%{
varprecision.Performance (computed) # register the performance for each trial and the average for each subject
-> varprecision.Recording
-----
stimuli    : longblob  # stimuli of all trials, in degs, size nTrials x max(set_size) for exp 5,7. first column is always the target
response   : longblob  # response of all trials, size nTrials x 1
set_size   : longblob  # number of items for each trial, size nTrials x 1
performance: longblob  # performance for each trial
avg_perf   : double    # average performance for all data
%}

classdef Performance < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.Recording & (varprecision.Subject & 'subj_type="real"')
    end
    
	methods(Access=protected)

		function makeTuples(self, key)
            [key.stimuli, key.response, key.set_size] = fetch1(varprecision.Data & key, 'stimuli','response','set_size');
            
            datapath = fetch1(varprecision.Experiment & key, 'data_path');
            [subjid, exp_id] = fetch1(varprecision.Recording & key, 'subj_initial', 'exp_id');
            files = dir([datapath '/' subjid '*.mat']);
            performance = [];
            stimuli = [];
            for ii = 1:length(files)
                load([datapath '/' files(ii).name]);
                if ismember(exp_id, [1:5,7])
                    performance = [performance; data(:,3)];    
                elseif exp_id == 6
                    performance = [performance; data(:,6)];
                elseif exp_id == 8
                    performance = [performance; data(:,4)];
                    stimuli = [stimuli; data(:,1:2)];
                elseif exp_id == 9
                    performance = [performance; data(:,4)];
                elseif exp_id == 10
                    performance = [performance; data.C_hat == data.C];
                elseif exp_id == 11
                    performance = [performance; datamatrix(:,3) == datamatrix(:,4)];
                    
                end
            end
            if exp_id == 8
               key.stimuli = stimuli;
            end
            key.performance = performance;
            key.avg_perf = mean(performance);
            
			self.insert(key)
		end
	end

end