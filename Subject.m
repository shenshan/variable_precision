%{
varprecision.Subject (manual) # table to store the info for subjects
subj_initial   : varchar(10)    # initial of the subject
-----
subj_sex="Unknown"  : enum('M','F','Unknown')   # sex
notes=null     : varchar(256)   # whatever wants to say
%}

classdef Subject < dj.Relvar
end