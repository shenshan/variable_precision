%{
varprecision.PerformanceSetsize (computed) # my newest table
-> varprecision.Performance
-----
setsizes : blob   # set sizes
perform_ss: blob  # average performance of each set size
%}

classdef PerformanceSetsize < dj.Relvar & dj.AutoPopulate
	
    properties
        popRel = varprecision.Performance & 'exp_id in (3,5,7,10,11)';
    end
    methods(Access=protected)

		function makeTuples(self, key)
            [set_size, performance] = fetch1(varprecision.Performance & key, 'set_size', 'performance');
            setsizes = unique(set_size);

            perform = zeros(1,length(setsizes));

            for ii = 1:length(setsizes)
                perform_rel = performance(set_size==setsizes(ii));
                perform(ii) = mean(perform_rel);
            end
            key.setsizes = setsizes;
            key.perform_ss = perform;
            
			self.insert(key)
		end
	end

end