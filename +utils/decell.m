function [outMat,ndim,len] = decell(inMat)
%DECELL Covert a cell array to a matrix with desired size
%   length of inMat becomes the last dimension of outMat, dim returns
%   number of dimesions for outMat, and len returns the size of the last dimension.

if ~iscell(inMat)
    outMat = inMat;
    ndim = 1;
    len = 1;
    return
end

if length(inMat)==1
    outMat = [inMat{:}];
else
    entry_exp = inMat(1);
    sz = size([entry_exp{:}]);
    outMat = [];
    for ii = 1:length(inMat);
        entry = inMat(ii);
        outMat = cat(length(sz)+1,outMat,[entry{:}]);
    end
end
outMat = squeeze(outMat);
sz = size(outMat);
ndim = length(sz); len = sz(end);
