%{
varprecision.ParamsRange (manual) # parameter ranges used for bps algorithm
-> varprecision.Model
-----
lower_bound : blob     # lower bound of parameter range 
upper_bound : blob     # upper bound of parameter range
plb  : blob # plausible lower bound
pub  : blob # plausible upper bound
start_point : blob     # start point of parameter searching
%}

classdef ParamsRange < dj.Relvar
    
end