function hout = groupbar(data,varargin)

% function groupbar(data,varargin)
%
% Barplots data in groups of rows with errorbars and significance test for
% all the pairs of each group
% Accepts data in:
%
% MF 2012-03

% SS 2016-07

params.thr = 0.05;
params.fontsize = 12;
params.markersize = 0.5;
params.names = [];
params.angle = 45;
params.sig = 0;
params.bar = 1;
params.error = 'sde';
params.colors = [];
% % params.colors = [0,1,0;
%                  1,1,0;
%                  0,0,1;
%                  1,0,1];

params = getParams(params,varargin);

% data = data';
values = cellfun(@nanmean,data);
if strcmp(params.error,'sde')
    errors = cellfun(@(x) nanstd(x)/sqrt(length(x)),data);
elseif  strcmp(params.error,'std')
    errors = cellfun(@(x) nanstd(x),data);
end

[nRows, nCols] = size(values);

if nCols == 1 || nRows ==1
    loc = 1:length(values);
else
    loc = bsxfun(@plus,repmat(linspace(0.8,1.3,nCols),nRows,1),(1:nRows)'-1);
    % 0.8,1.4 for group plots
end

%%%%%% edit for matlab 2014b
colors = parula(nCols);
for i = 1:nCols
    handles.bar(i) = bar(loc(:,i),values(:,i),'barwidth',0.65/nCols,... * 0.75 for amplitude plots
        'faceColor',colors(i,:),'edgeColor',[1,1,1]); % standard implementation of bar fn
    hold on
end
%%%%%%

if ~isempty(params.colors)
    for i = 1:nCols
        set(handles.bar(i),'EdgeColor','none','FaceColor',params.colors(i,:));
    end
end
hold on

if nRows > 1
    %     loc = nan(nRows,nCols);
    for col = 1:nCols
        % Extract the x location data needed for the errorbar plots:
        %         loc(:,col) = mean(get(get(handles.bar(col),'children'),'xdata'),1);
        % Use the mean x values to call the standard errorbar fn; the
        % errorbars will now be centred on each bar:
        e = errorbar(loc(:,col),values(:,col),errors(:,col),'k','LineStyle','None');
        c = get(e,'children');
        x = get(c(2),'xData');
        x2 = reshape(x,9,[]);
        x2([4,7],:) = x2([4,7],:)+0.07;
        x2([5,8],:) = x2([5,8],:)-0.07;
        set(c(2),'xData',x2(:).');
    end
else
    %     loc = mean(get(get(handles.bar,'children'),'xdata'),1);
    errorbar(loc,values,errors,'.k')
end

mx = max((values(:)) + errors(:));
if params.bar;mx = max([0 mx]);end
vsp = ( max(abs(values(:)) + errors(:)))*0.1;

if params.sig
    df =  mean(mean(diff(loc')));
    hsp = df*0.1;
    if nCols==1
        data = data';
        [nRows, nCols] = size(data);
    end
    for iRow = 1:nRows
        [~,seq] = sort(pdist(reshape(loc(iRow,:),[],1)));
        
        if nCols>2
            idx =squareform(1:length(seq));
            idx(logical(tril(ones(nCols),-1))) = 0;
            [xind, yind]= find(idx);
        else xind = 1;yind =2;
        end
        
        % correct error distances
        x1 = loc(xind(seq));
        x2 = loc(yind(seq));
        xd = loc(yind(seq)) - loc(xind(seq));
        uni = unique(xd);
        space = xd;
        for i = 2:length(uni)
            pairs = nchoosek(find(xd==uni(i)),2);
            if size(pairs,2)>1
                for ipair = 1:size(pairs,1)
                    [~,xi] = sort(x1(pairs(ipair,:)));
                    if x1(pairs(ipair,xi(2)))<x2(pairs(ipair,xi(1))) && ...
                            space(pairs(ipair,xi(2))) == space(pairs(ipair,xi(1)))
                        indx = false(size(space));
                        indx(pairs(ipair,xi(2))) = true;
                        indx(xd>uni(i)) = true;
                        space(indx) = space(indx)+1;
                    end
                end
            end
        end
        
        % plot the erros if significant
        for iPair = 1:length(seq)
            [sig, p] = ttest2(data{iRow,xind(seq(iPair))},...
                data{iRow,yind(seq(iPair))},params.thr);
            if sig
                x1 = loc(iRow,xind(seq(iPair)));
                x2 = loc(iRow,yind(seq(iPair)));
                plot([x1+hsp x2-hsp],...
                    [mx+vsp*space(iPair) mx+vsp*space(iPair)],'k');
                text( roundall(mean([x1,x2]),0.001),...
                    double(mx+vsp*space(iPair)+vsp/2),pval(p),...
                    'FontSize',params.fontsize,'HorizontalAlignment',...
                    'center','VerticalAlignment','cap')
            end
        end
    end
end

set(gca,'ylim',[min([0 min(values(:) - 2*errors(:))]) mx+vsp*(nCols+1)])
set(gca,'Box','Off');
set(gca,'FontSize',params.fontsize);
set(gca,'Xtick',1:nRows)
if ~isempty(params.names)
    set(gca,'XTickLabel',params.names)
    if nCols==1
        ht = xticklabel_rotate([],params.angle,[]);
        set(ht,'HorizontalAlignment','right')
    end
end

if ~params.bar
    delete(handles.bar)
    handles.bar = plot(values);
    set(gca,'xtick',1:length(values))
end
hold off

if nargout
    hout = handles.bar;
end

function ast = pval(p)
if p<0.01
    ast = '**';
elseif p<0.001
    ast = '***';
else ast = '*';
end


