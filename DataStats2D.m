%{
varprecision.DataStats2D (computed) # save some statistics of the data
-> varprecision.Data
-----
cnt_l              : longblob     # number of trials that the subject reports left for indivisual setsize and stimulus
cnt_r              : longblob     # number of trials reports right
cnt                : longblob     # number of total trials
p_right            : longblob     # number of probability of reporting right, same size as p_right
stims              : longblob     # unique stimuli shown to the subjects, or binned stimuli
dist               : longblob     # bin of distractor orientation
idx_target         : longblob     # index for target stimuli
idx_dist           : longblob     # index for distractor stimuli
%}

classdef DataStats2D < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.Data & 'exp_id in (6,9)'
    end
    
    methods(Access=protected)

		function makeTuples(self, key)
            
            stims = (-16:2:16)';
            dist = [-10,0,10];

            [stimuli,response,set_size] = fetch1(varprecision.Data & key, 'stimuli','response','set_size');
            target_stimuli = stimuli(:,1);
            dist_stimuli = stimuli(:,2:end);
            
            if ismember(key.exp_id,[6,7])
                [~, min_idx] = min(abs(dist_stimuli),[],2);
                min_idx = sub2ind(size(dist_stimuli),(1:length(dist_stimuli))',min_idx);
                min_dist_stimuli = dist_stimuli(min_idx);
            else
                min_dist_stimuli = dist_stimuli(:,1);
            end

            idx1 = interp1(stims,1:length(stims),target_stimuli,'nearest','extrap');
            idx2 = interp1(dist,1:length(dist),min_dist_stimuli, 'nearest','extrap');
            setsizes = unique(set_size);

            if length(setsizes)==1
                cnt_r = zeros(length(stims),length(dist));
                cnt_l = zeros(length(stims),length(dist));

                for ii = 1:length(stims)
                    for jj = 1:length(dist)
                        response_sub = response(idx1==ii & idx2==jj);
                        cnt_l(ii,jj) = sum(response_sub==-1);
                        cnt_r(ii,jj) = sum(response_sub==1);
                    end
                end
                
                % need to be fixed for Exp 7
            else
                cnt_r = zeros(length(setsizes),length(stims),length(dist));
                cnt_l = zeros(length(setsizes),length(stims),length(dist));

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
            
            cnt = cnt_r + cnt_l;
            p_right = cnt_r./cnt;
            
            key.cnt_l = cnt_l;
            key.cnt_r = cnt_r;
            key.cnt = cnt;
            key.p_right = p_right;
            key.stims = stims;
            key.dist = dist;
            key.idx_target = idx1;
            key.idx_dist = idx2;
			
            self.insert(key)
		end
	end

end