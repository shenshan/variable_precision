%{
varprecision.InitialPoint (manual) # my newest table
-> varprecision.Recording
-> varprecision.ParamsRange
int_point_id : int    # index of initial point
-----
initial_point : blob     # initial point of parameter searching
%}

classdef InitialPoint < dj.Relvar
end