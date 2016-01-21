function insertParameters(exp_ids, model, parset_id, varargin)
%INSERTPARAMETERS inserts parameter sets into the table varprecision.ParameterSet
%   exp_id specifies the experiments, could be a scalar or a vector. model
%   sepcifies the name of the model, should be from {'CP','CPG','VP','VPG'}

% parse inputs
if length(varargin)<2 || (ismember(model,{'CPG','VP'}) && length(varargin)<3) || (strcmp(model,'VPG') && length(varargin)<4)
    error('Not enough input arguments.')
end

p_right = varargin(1); key.p_right = p_right{:};
lambda = varargin(2); key.lambda = lambda{:};
key.model_name = model;
key.parset_id = parset_id;

switch model
    case 'CPG'
        guess = varargin(3); key.guess = guess{:};      
    case 'VP'
        theta = varargin(3); key.theta = theta{:};
    case 'VPG'
        theta = varargin(3); key.theta = theta{:};
        guess = varargin(4); key.guess = guess{:};
end

% insert tuples
for ii = exp_ids
    key_insert = key;
    key_insert.exp_id = ii;
    insert(varprecision.ParameterSet,key_insert);
end

