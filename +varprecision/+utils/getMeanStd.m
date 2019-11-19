function [out_mean, out_s] = getMeanStd(inputMat,type,dim)
%GETMEANSTD computes mean and standard error of the mean for a given matrix
%   function [out_mean, out_s] = getMeanStd(inputMat,type,dim)
%   type specifies what kind of variance
%   dim specifies which dimension to compute mean and sem
%   type specifies sem or std

if ~exist('type','var')
    type = 'sem';
end
if ~exist('dim', 'var')
    dim = 1;
end
assert(ismember(type, {'sem', 'std'}),'Invalid type input, please enter sem or std.')

out_mean = nanmean(inputMat,dim);

switch type
    case 'sem'
        out_s = nanstd(inputMat,[],dim)/sqrt(size(inputMat,dim));
    case 'std'
        out_s = nanstd(inputMat,[],dim);
end