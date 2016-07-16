% This script aims to show Weiji suboptimal rule fits better than the
% optimal rule in Exp 6

f = eval('@varprecision.utils.decell');

lml_CP = fetchn(varprecision.FitParametersEvidence & 'exp_id=6' & 'parset_id=2' & 'jkmap_id=2' & 'model_name="CP"','lml');
lml_CPG = fetchn(varprecision.FitParametersEvidence & 'exp_id=6' & 'parset_id=2' & 'jkmap_id=2' & 'model_name="CPG"','lml');

lml_VP = fetchn(varprecision.FitParametersEvidence & 'exp_id=6' & 'parset_id=2' & 'jkmap_id=2' & 'model_name="VP"','lml');
lml_VPG = fetchn(varprecision.FitParametersEvidence & 'exp_id=6' & 'parset_id=2' & 'jkmap_id=2' & 'model_name="VPG"','lml');

lml_VP_sub = fetchn(varprecision.FitParametersEvidence & 'exp_id=6' & 'parset_id=1' & 'jkmap_id=2' & 'model_name="VP"','lml');
lml_VPG_sub = fetchn(varprecision.FitParametersEvidence & 'exp_id=6' & 'parset_id=1' & 'jkmap_id=2' & 'model_name="VPG"','lml');

lml_CP_mat = f(lml_CP);
lml_CPG_mat = f(lml_CPG);
lml_VP_mat = f(lml_VP);
lml_VPG_mat = f(lml_VPG);
lml_VP_sub_mat = f(lml_VP_sub);
lml_VPG_sub_mat = f(lml_VPG_sub);

bar_mat = [lml_CP_mat,lml_CPG_mat,lml_VP_mat,lml_VPG_mat,lml_VP_sub_mat,lml_VPG_sub_mat];

bar_mat = bsxfun(@minus, bar_mat, lml_VPG_sub_mat);

fig = Figure(105,'size',[60,40]); hold on       
bar_custom(bar_mat(:,1:5),'mean')

set(gca,'XTick',1:size(bar_mat,2)-1,'XTickLabel',{'CP','CPG','VP','VPG','VP_sub'})
