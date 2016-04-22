function [stimuli,response,set_size] = readData(key,type)
%READDATA load the data from .mat file
%   function [stimuli,response,set_size] = readData(key,type)
%   type specifies which type of data to read, real or fake.

    assert(ismember(type, {'real','fake'}), 'Invalid type input, please enter real or fake.')
    datapath = fetch1(varprecision.Experiment & key, 'data_path');
    [subjid, exp_id] = fetch1(varprecision.Recording & key, 'subj_initial', 'exp_id');
    % get list of filenames
    files = dir([datapath '/' subjid '*.mat']);
    
    % read every file
    stimuli = [];
    response = [];
    set_size = [];
    
    for ii = 1:length(files)
        load([datapath '/' files(ii).name]);
        if ismember(exp_id, [1,2,4])
            stimuli = [stimuli; data(:,1)];
            response = [response; data(:,2)];
            set_size = [set_size; 1];
        elseif ismember(exp_id, [3,5])
            stimuli = [stimuli; data(:,1)];
            response = [response; data(:,2)];
            if strcmp(type,'fake')
                set_size = [set_size; data(:,3)];
            else
                set_size = [set_size; data(:,5)];
            end
        elseif exp_id == 6
                stimuli = [stimuli; data(:,1:4)];
                response = [response; data(:,5)];
                set_size = [set_size; 4];
        elseif exp_id == 7
                stimuli = [stimuli; data(:,[1,8:10])];
                response = [response; data(:,2)];
                set_size = [set_size; data(:,5)];
        elseif exp_id == 8
                stimuli = [stimuli; data(:,1:2)];
                response = [response; data(:,3)];
                set_size = [set_size; 2];
        elseif exp_id == 9
                stimuli = [stimuli; data(:,1:2)];
                response = [response; data(:,3)];
                set_size = [set_size; 2];
        elseif exp_id == 10
                stimuli = [stimuli; data.orts];
                response = [response; data.C_hat];
                set_size = [set_size; data.N];        
        end
    end
    
    % adjust the size of the stimuli to nTrials x max(set_size)
    switch exp_id
        case [2,3]
            stimuli = repmat(stimuli,1,4);
        case [4,5]
            stimuli = [stimuli,zeros(length(stimuli),3)];
        case 9
            stimuli = [stimuli(:,1), repmat(stimuli(:,2),1,3)];
    end
    
    