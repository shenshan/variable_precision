function key = randKey(inputTable,type,varargin)
    % get a random key from a table
    if ~exist('type','var')
        type = 'primary';
    end
    keys = fetch(inputTable & varargin);
    key = keys(randi(length(keys)));
    
    if strcmp(type,'all')
        key = fetch(inputTable & key, '*');
    end