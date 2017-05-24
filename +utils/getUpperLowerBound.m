function [patch,out_mean,out_sem,out_up,out_low] = getUpperLowerBound(inputMat,dim,dim2)
%GETUPPERLOWERBOUND compute the mean, sem, upper bound, lower bound and
%patchy edges of a matrix for a give dimension
%   dim specifies which dimension to compute the mean and sem
%   dim2 indicates which dimension to wrev.

if ~exist('dim2','var')
    dim2 = 1;
end
out_mean = squeeze(nanmean(inputMat,dim));
out_sem = squeeze(nanstd(inputMat,[],dim)/sqrt(size(inputMat,dim)));

out_up = out_mean + out_sem;
out_low = out_mean - out_sem;

if iscolumn(out_up) || dim2==2
    out_up = out_up';
    out_low = out_low';
end

patch = [out_up, fliplr(out_low)];

