%{
varprecision.DataStats (computed) # save some statistics of the data
-> varprecision.Data
-----
cnt_l              : longblob     # number of trials that the subject reports left for indivisual setsize and stimulus
cnt_r              : longblob     # number of trials reports right
cnt                : longblob     # number of total trials
p_right            : longblob     # number of probability of reporting right, same size as p_right
stims              : longblob     # unique stimuli shown to the subjects, or binned stimuli
%}

classdef DataStats < dj.Relvar & dj.AutoPopulate
	
    properties 
        popRel = varprecision.Data & 'exp_id<10'
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            [stimuli_real,response,set_size] = fetch1(varprecision.Data & key,'stimuli','response','set_size');
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            
            if key.exp_id<6
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
                    for ii = 1:length(setsizes)
                        response_sub = response(set_size==setsizes(ii));
                        stimuli_sub = stimuli_real(set_size==setsizes(ii));
                        for jj = 1:length(stimuli)
                            response_sub2 = response_sub(stimuli_sub==stimuli(jj));
                            cnt_r(ii,jj) = sum(response_sub2==1);
                            cnt_l(ii,jj) = length(response_sub2) - cnt_r(ii,jj);
                        end
                    end

                 end
            
            elseif ismember(key.exp_id,[6,7,8,9])
                stims = (-16:2:16)';
                
                [stimuli,response,set_size] = fetch1(varprecision.Data & key, 'stimuli','response','set_size');
                
                if key.exp_id==8
                    target_stimuli = stimuli(:,1) - stimuli(:,2);
                else
                    target_stimuli = stimuli(:,1);
                end
                idx = interp1(stims,1:length(stims),target_stimuli,'nearest','extrap');
                setsizes = unique(set_size);

                if length(setsizes)==1
                    cnt_r = zeros(size(stims));
                    cnt_l = zeros(size(stims));
                   
                    for ii = 1:length(stims)
                        response_sub = response(idx==ii);
                        cnt_l(ii) = sum(response_sub==-1);
                        cnt_r(ii) = sum(response_sub==1);
                    end
                else
                    cnt_r = zeros(length(setsizes),length(stims));
                    cnt_l = zeros(length(setsizes),length(stims));
                   
                    for jj = 1:length(setsizes)
                       idx_ss = idx(set_size==setsizes(jj));
                       response_ss = response(set_size==setsizes(jj));
                       for ii = 1:length(stims)
                           response_sub = response_ss(idx_ss==ii);
                           cnt_l(jj,ii) = sum(response_sub==-1);
                           cnt_r(jj,ii) = sum(response_sub==1);
                       end
                    end
                end
                stimuli = stims;
            end
            
            cnt = cnt_r + cnt_l;
            p_right = cnt_r./cnt;
            
            key.cnt_l = cnt_l;
            key.cnt_r = cnt_r;
            key.cnt = cnt;
            key.p_right = p_right;
            key.stims = stimuli;
			
            self.insert(key)
		end
	end

end