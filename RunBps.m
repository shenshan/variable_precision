%{
varprecision.RunBps (manual) # multiple runs for bps
->varprecision.InitialPoint
run_idx : int     # index if run
-----
trial_num_sim : int   # simulation trial number
%}

classdef RunBps < dj.Relvar
end