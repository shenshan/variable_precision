function [patch,out_mean,out_sem,out_up,out_low] = getUpperLowerBound(inputMat,dim)
%GETUPPERLOWERBOUND compute the mean, sem, upper bound, lower bound and
%patchy edges of a matrix for a give dimension
%   dim specifies which dimension to compute the mean and sem

out_mean = squeeze(mean(inputMat,dim));
out_sem = squeeze(std(inputMat,[],dim)/sqrt(size(inputMat,dim)));

out_up = out_mean + out_sem;
out_low = out_mean - out_sem;

if isvector(out_up) && size(out_low,2)==1
    out_up = out_up';
    out_low = out_low';
end
        
patch = [out_up, fliplr(out_low)];

