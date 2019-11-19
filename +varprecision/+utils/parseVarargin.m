function [str,idx] = parseVarargin(tag, input)
%PARSEVARARGIN returns the str of varargin that contains tag
%   Example: [str, idx] = parseVarargin('subj','subj_initial="SS"','model_name="VPG"')
%            returns str = 'subj_initial="SS"'; idx = 1;

idx = ~cellfun(@isempty,strfind(input,tag));
idx = find(idx==1);
str = input(idx);




