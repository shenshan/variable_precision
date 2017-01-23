%{
varprecision.Subject (manual) # table to store the info for subjects
subj_initial    : varchar(10)            # initial of the subject
---
subj_sex="Unknown"          : enum('M','F','Unknown')       # sex
notes=null                  : varchar(256)                  # whatever wants to say
subj_type=null              : enum('real','fake','real_sub') # whether this is a real subject, real_sub refers to the data of a sub set size
model_gene="N/A"            : enum('CP','CPG','VP','VPG','OP','OPG','XP','XPG','OPVP','OPVPG','XPVP','XPVPG','N/A') # model to generate fake data
fake_idx=0                  : tinyint                       # fake data index
fake_param_method="N/A"     : enum('real','random','N/A')   # method to generate fake data parameters
set_size=0                  : tinyint                       # set size of the data set
%}

classdef Subject < dj.Relvar
end
