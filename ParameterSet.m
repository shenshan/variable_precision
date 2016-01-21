%{
varprecision.ParameterSet (manual) # parameter settings for each model
-> varprecision.Model
parset_id      : tinyint      # index of the parameter set
-----
p_right        : blob         # prior probability of reporting right
lambda         : blob         # lambda or kappa, encoding precision, in degs or rads
theta = null   : blob         # scale factor of encoding precision, in degs or rads
guess = null   : blob         # guessing rate        
%}

classdef ParameterSet < dj.Relvar
end