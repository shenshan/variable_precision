function readdata
save_dir = '/Users/shanshen/Dropbox/Shan_VR/Exp9_final_models/data_for_weiji/';

subjids = {'MBC','MG','RC','SS','WYZ','XLM','YC','YL','YMH','YZ'};

for ii = 1:length(subjids)
    subjid = subjids{ii};
    files = dir([subjid '*.mat']);
    
    data_all = [];
    for jj = 1:length(files)
        load(files(jj).name);
        data_all = [data_all;data(:,1:3)];
        
    end
    save([save_dir subjid '.mat'],'data_all');
end