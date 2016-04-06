%{
varprecision.DataStats (computed) # save some statistics of the data
-> varprecision.Data
-----
cnt_l              : longblob     # number of trials that the subject reports left for indivisual setsize and stimulus
cnt_r              : longblob     # number of trials reports right
cnt                : longblob     # number of total trials
p_right            : longblob     # number of probability of reporting right, same size as p_right
%}

classdef DataStats < dj.Relvar & dj.AutoPopulate
	
    properties 
        popRel = varprecision.Data & 'exp_id<6'
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            [stimuli_real,response] = fetch1(varprecision.Data & key,'stimuli','response');
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            stimuli = unique(stimuli_real);
            
            if length(setsizes)==1
                cnt_r = zeros(size(stimuli));
                cnt_l = zeros(size(stimuli));
                for ii = 1:length(stimuli)
                    response_sub = response(stimuli_real==stimuli(ii));
                    cnt_r(ii) = sum(response_sub==1);
                    cnt_l(ii) = length(response_sub) - cnt_r(ii);
                end
                
            else
                cnt_r = zeros(length(setsizes),length(stimuli));
                cnt_l = zeros(length(setsizes),length(stimuli));
                for ii = 1:length(stimuli)
                    response_sub = response(stimuli_real==stimuli(ii));
                    cnt_r(ii) = sum(response_sub==1);
                    cnt_l(ii) = length(response_sub) - cnt_r(ii);
                end
               
            end
            cnt = cnt_r + cnt_l;
            p_right = cnt_r./cnt_l;
            
            key.cnt_l = cnt_l;
            key.cnt_r = cnt_r;
            key.cnt = cnt;
            key.p_right = p_right;
			
            self.insert(key)
		end
	end

end