function pairwiseAIC(exps_res, model_res1, model_res2, tail, cmp_type)
%PAIRWISEAIC computes the sign-rank p values of all pairs of models in an
%experiment, the iith row and jjth column represents the p value of modelii
%greater than modeljj

if ~exist('cmp_type','var')
    cmp_type = 'aic';
end
if ~exist('tail','var')
    cmp_type = 'one';
end
exps = fetch(varprecision.Experiment & exps_res);

exp_names = [1,8,2,3,4,5,9,10,6,7,11];

for iexp = exps'
    
    filename = ['~/Dropbox/VR/+varprecision/stat_results/pairwiseAIC_exp' num2str(exp_names(iexp.exp_id)) '_' cmp_type '_' tail '.csv'];
    models1 = fetch(varprecision.Model & iexp & 'model_name not in ("XP","XPG","XPVP","XPVPG")' & model_res1);
    models2 = fetch(varprecision.Model & iexp & 'model_name not in ("XP","XPG","XPVP","XPVPG")' & model_res2);
    model_names1 = fetchn(varprecision.Model & models1, 'model_name');
    model_names2 = fetchn(varprecision.Model & models2, 'model_name');
    
    pMat = cell(length(models1)+1,length(models2)+1);
    
    pMat(1,2:length(models2)+1) = model_names2';
    pMat(2:length(models1)+1,1) = model_names1;
    
    for ii = 1:length(models1)
        Mat1 = fetchn(varprecision.FitParsEviBpsBestAvg & iexp & models1(ii), cmp_type);
        for jj = 1:length(models2)
            Mat2 = fetchn(varprecision.FitParsEviBpsBestAvg & iexp & models2(jj), cmp_type);
            if ii == jj && length(models1)==length(models2)
                pMat{ii+1,jj+1} = num2str(0);
            else
                if strcmp(tail, 'one')
                    pMat{ii+1,jj+1} = num2str(ttest(Mat1, Mat2, 'tail', 'left'),2);
                else
                    pMat{ii+1,jj+1} = num2str(ttest(Mat1, Mat2),2);
                end
            end
        end
    end

    fid = fopen(filename,'wt');
    nrows = size(pMat,1);
    
    for ii = 1:nrows
        fprintf(fid,'%s,', pMat{ii,1:end-1});
        fprintf(fid,'%s\n', pMat{ii,end});
    end
    
    fclose(fid);
    
end


