%{
varprecision.Model (manual) # models considered
-> varprecision.Experiment
model_name   : varchar(50)        # model names 
-----
notes=null         : varchar(256)       # notes for this model
%}

classdef Model < dj.Relvar
end