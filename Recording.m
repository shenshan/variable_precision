%{
varprecision.Recording (manual) # data information
-> varprecision.Experiment
-> varprecision.Subject
-----
notes     : varchar(256)    # if have something to say
%}

classdef Recording < dj.Relvar
end