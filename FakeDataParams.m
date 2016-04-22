%{
varprecision.FakeDataParams (manual) # table that saves parameters used to generate the fake data
->varprecision.Subject
->varprecision.Experiment
-----
p_right : double      # prior
lambda  : blob        # lambda, a vector or scalar, depends on different experiments
theta   : double      # scale factor of gamma distribution to discribe precision
guess   : double      # lapse rate
method = "unknown"  : enum('random','real','unknown') # mehthod to generate fake data paramters, 'real' indicates generation based on real paramters, 'random' indicates randomly selected on the corresponding paraset range.
%}

classdef FakeDataParams < dj.Relvar
end