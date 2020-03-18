function Fig = hist_symbreaking(DIRS,Rlimits,append)
% SCATTER_DISPLACEMENT
% function Fig = scatter_displacement(DIRS,append)
% figure saved to first directory in DIRS.
%
% input
% DIRS      cell array of data directories, columns will be loaded together and
% plotted in a different color.
%
% append    optional. string to append to figure name and filename.
%
% output
% Fig       figure handle.

% limits on drop diameter
Lmin = 30;
Lmax = 200;

% DIRS = varargin;
S = size(DIRS);

fields={'blobDistanceMinusPlus','dropRadius','dropEffectiveRadius'};
if iscellstr(DIRS)
    dropVectors = loadDropsVectors(DIRS,fields);
elseif isstruct(DIRS)
    dropVectors = DIRS;
end

% dropVectors = loadDropsVectors(DIRS,fields);

for rangeInd = 1:size(Rlimits,1);
    Dl = Rlimits(rangeInd,:);
    Rl =Dl / 2;
% figure size 500x350
Fig(rangeInd) = figure('Position',[100 100 400 200]);
Fig(rangeInd).PaperPositionMode = 'auto';

hold on

% figure name prefix
Fig(rangeInd).Name = sprintf('symbreaking histogram %d - %d microns - ',round(Dl(1)),round(Dl(2)));
for i = 1:S(1)
    % plot
    blobDistanceMinusPlus = [dropVectors(i,:).blobDistanceMinusPlus];
    dropEffectiveRadius = [dropVectors(i,:).dropEffectiveRadius];
    dropInd = [dropVectors(i,:).dropRadius] >= Rl(1) & [dropVectors(i,:).dropRadius] < Rl(2);
    rN = blobDistanceMinusPlus(1,dropInd)./dropEffectiveRadius(dropInd);
    rN(rN>1) = 1;
    symbreaking_hist(i) = histogram(rN,0:0.1:1,'EdgeColor','none','FaceColor',[0.3,0.3,0.3],'Normalization','probability');
    % string to dispaly in legend
    symbreaking_hist(i).DisplayName = sprintf('%s, N=%d',dropVectors(i,1).description, length([dropVectors(i,:).dropRadius]));
    legend('off');
    
    % add description to figure name
    Fig(rangeInd).Name = [Fig(rangeInd).Name, dropVectors(i,1).description];
    if i<S(1)
        Fig(rangeInd).Name = [Fig.Name, ', '];
    elseif exist('append','var')
        Fig(rangeInd).Name = [Fig.Name, append];
    end
end

title(sprintf('%d - %d \\mum',round(Dl(1)),round(Dl(2))));
xlim([0,1]);
ax = gca;
ax.YTick = [];
ax.XTick = [0.15,0.91];
ax.TickLength = [0 0];
ax.XTickLabel = {'Centered', 'Polar'};
ax.FontSize = 18;
ax.LabelFontSizeMultiplier = 1;

%XD = [displacement_hist.XData];
%YD = [displacement_hist.YData];
%[maxY,Ind] = max(YD);
%ylim([0,max(round(XD(Ind)/2),maxY)]);

% plot drop radius and effective radius
%plot(Lmin:Lmax , (Lmin:Lmax) / 2,'k--');
%plot(Lmin:Lmax , (Lmin:Lmax)*(1-(0.7^2/15/2)^(1/3)) / 2,'r--');

hold off
%h = legend(displacement_plot,'location','best');
%h.FontSize = 14;

% save figure
if iscellstr(DIRS)
    print(Fig(rangeInd),fullfile(DIRS{1},[Fig(rangeInd).Name,'.eps']),'-depsc');
end
end
end