%{
varprecision.Subject (manual) # table to store the info for subjects
subj_initial    : varchar(10)            # initial of the subject
---
subj_sex="Unknown"          : enum('M','F','Unknown')       # sex
notes=null                  : varchar(256)                  # whatever wants to say
subj_type=null              : enum('real','fake')           # whether this is a real subject
model_name="N/A"            : enum('CP','CPG','VP','VPG','N/A') # model to generate fake data
fake_idx=0                  : tinyint                       # fake data index
fake_param_method="N/A"     : enum('real','random','N/A')   # method to generate fake data parameters
%}

classdef Subject < dj.Relvar
end
