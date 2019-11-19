%{
varprecision.PredTableFake (computed) # combine sub tables
-> varprecision.ParameterSet
-> varprecision.JbarKappaMap
-----
predtable_dir : blob      # directory to save the full prediction table
%}

classdef PredTableFake < dj.Relvar & dj.AutoPopulate
    
    properties
        popRel = varprecision.ParameterSet * varprecision.JbarKappaMap & varprecision.PreSubTableFake
    end
    
    methods(Access=protected)
		function makeTuples(self, key)
            % return without inserting tuples if not all sub tables are populated
            lambda = fetch1(varprecision.ParameterSet & key,'lambda');           
            keys = fetch(varprecision.PreSubTableFake & key);
            if length(lambda)~=length(keys)
                return
            end
            setsizes = fetch1(varprecision.Experiment & key, 'setsize');
            predtable_combined = [];
            
            for ii = 1:length(keys)
                key_subtable = keys(ii);
                path = fetch1(varprecision.PreSubTableFake & key_subtable,'pretable_sub_dir');
                load(path)
                sz = size(predtable);
                predtable_combined = cat(length(sz)+1,predtable_combined,predtable);
            end
           
     
            if length(setsizes)==1
                ll_mat = permute(ll_mat,[1:2,length(sz)+1,3:length(sz)]);
            else
                ll_mat = permute(ll_mat,[1:3,length(sz)+1,3:length(sz)]);
            end
            predtable_dir = ['~/Dropbox/VR/+varprecision/results/fake_table/exp_' num2str(key.exp_id) '/table_combined/'];
            
            if ~exist(ll_mat_path,'dir')
                mkdir(ll_mat_path)
            end
            filename = [key.model_name '_' num2str(key.parset_id) '.mat'];
            
            key.ll_mat_path = [ll_mat_path filename];
            save(key.ll_mat_path,'ll_mat');            
            
            self.insert(key)
            
		end
	end

end