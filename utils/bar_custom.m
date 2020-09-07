function handles = bar_custom(data,mode,w)
%Bar plots of group data
%   input form should be a matrix nSubjs * nModels 
if ~exist('mode','var')
    mode = 'group';
end
if ~exist('w','var')
    w = 1;
end
[nRows, nCols] = size(data);
if strcmp(mode, 'group')
    width = 0.5;
elseif strcmp(mode, 'mean')
    data2 = data;
    data = mean(data2);
    err = std(data2)/sqrt(nRows);
    width = 2;
    nRows = 1;
else
    assert('invalid mode input, please enter "group" or "mean".')
end


if nCols == 1 || nRows ==1
    loc = 1:length(data);
else
    loc = bsxfun(@plus,repmat(linspace(0.8,1.4,nCols),nRows,1),w*(1:nRows)'-1);
    % 0.8,1.4 for group plots
end

if nCols==3
    colors = [0.5,0.7,1;0.7,0.8,0.4;1,0.5,0.5];
else
    colors = parula(nCols);
end


for i = 1:nCols
    handles.bar(i) = bar(loc(:,i),data(:,i),'barwidth',width/nCols,... * 0.75 for amplitude plots
        'faceColor',colors(i,:),'edgeColor','None'); % standard implementation of bar fn
    hold on
    if strcmp(mode, 'mean')
        handles.errbar(i) = errorbar(loc(:,i),data(:,i),err(:,i), 'Color',max(colors(i,:)-0.4,0),'LineStyle','None');
    end
    hold on
end

if strcmp(mode, 'group')
    xlim([0,nRows]*w*1.1)
end