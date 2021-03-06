%{
# experiment each subject did
exp_id          : int                    # experiment id
---
exp_type="Discrimination"   : enum('Discrimination','Detection','Change Localization','Other') # type of experiment
setsize                     : blob                          # set size
ntargets                    : blob                          # number of targets
data_path                   : varchar(256)                  # data path
exp_description=null        : varchar(256)                  # describe the experiment
sigma_s                     : double                        # width of gaussian distribution of the stimuli, in degs or rads
%}

classdef Experiment < dj.Manual
end
