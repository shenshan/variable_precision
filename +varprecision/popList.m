
subjs = fetch(varprecision.Subject & 'subj_type="real"');
parpopulate(varprecision.FitParsEviBpsRun,'exp_id in (2,3)','int_point_id in (1,2,3,4,5,6,7,8,9,10)','model_name not in ("XP","XPG","XPVP","XPVPG")',subjs);
parpopulate(varprecision.FitParsEviBpsRunBest,'exp_id in (2,3)','int_point_id in (1,2,3,4,5,6,7,8,9,10)','model_name not in ("XP","XPG","XPVP","XPVPG")',subjs);
parpopulate(varprecision.FitParsEviBpsRun,'exp_id in (4,5,9)','int_point_id in (1,2,3,4,5)','model_name not in ("XP","XPG","XPVP","XPVPG")',subjs);
parpopulate(varprecision.FitParsEviBpsRun,'exp_id in (4,5,9)','int_point_id in (1,2,3,4,5,6,7,8,9,10)','model_name not in ("XP","XPG","XPVP","XPVPG")',subjs);