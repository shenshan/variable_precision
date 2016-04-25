function [outMat,dim,len] = decell(inMat)
%DECELL Covert a cell array to a matrix with desired size
%   length of inMat becomes the last dimension of outMat, dim returns
%   number of dimesions for outMat, and len returns the size of the last dimension.

if ~iscell(inMat)
    outMat = inMat;
    dim = 1;
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

sz = size(outMat);
dim = length(sz); len = sz(end);
