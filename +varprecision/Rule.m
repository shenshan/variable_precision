%{
varprecision.Rule (lookup) # table for all rules in Experiment 9
rule_name    : varchar(16)  # name of a decision rule
-----
rule_class   : varchar(16)  # class of a decision rule
%}

classdef Rule < dj.Relvar
    methods
        function fill(self)
            rule_names = {'Opt','Min','Max','Sum','Var','Sign','Max2','Max12','Max13','Max23','Max123','SumErf','SumErf1','SumErf2','SumErf3','SumErf12','SumErf13','SumErf23','SumX1','SumX2','SumX3','SumX12','SumX13','SumX23','SumX123'};
            
            for ii = 1:length(rule_names)
                tuples(ii).rule_name = rule_names{ii};
                if strcmp(rule_names{ii},'Opt')
                    tuples(ii).rule_class = 'Opt';
                elseif ismember(rule_names{ii},{'Min','Max','Sum','Var','Sign'})
                    tuples(ii).rule_class = 'Simple';
                elseif ~isempty(strfind(rule_names{ii},'Max')) && ~strcmp(rule_names{ii},'Max')
                    tuples(ii).rule_class = 'Max';
                elseif ~isempty(strfind(rule_names{ii},'SumErf'))
                    tuples(ii).rule_class = 'SumErf';
                elseif ~isempty(strfind(rule_names{ii},'SumX'))
                    tuples(ii).rule_class = 'SumX';
                else
                    tuples(ii).rule_class = 'Other';
                end   
            end
            
            self.inserti(tuples)            
        end
    end
end