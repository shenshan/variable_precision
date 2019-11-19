
exps = fetch(varprecision.Experiment & 'exp_id in (4)');

subjs = fetch(varprecision.Subject & 'subj_type="real"');
del(varprecision.EviFactor & exps & subjs)
del(varprecision.EviFactorAdd & exps & subjs)
del(varprecision.EviFactor2 & exps & subjs)

populate(varprecision.EviFactor, exps, subjs)
populate(varprecision.EviFactorAdd, exps, subjs)
populate(varprecision.EviFactor2, exps, subjs)