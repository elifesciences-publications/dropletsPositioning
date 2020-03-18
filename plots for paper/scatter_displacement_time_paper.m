function Fig = scatter_displacement_time_papaer(DIRS,sigma,lims,plotAvg,sectionLines,append)
% SCATTER_DISPLACEMENT
% function Fig = scatter_displacement(DIRS,append)
% scatter plot of blob displacement and drop diameter for each drop in data
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
if exist('lims', 'var')
    Lmin = lims(1);
    Lmax = lims(2);
else
    Lmin = 30;
    Lmax = 90;
end
if ~exist('plotAvg', 'var')
    plotAvg = true;
end
S = size(DIRS);

fields={'blobDistanceMinusPlus','dropRadius','dropEffectiveRadius'};
if iscellstr(DIRS)
    dropVectors = loadDropsVectors(DIRS,fields);
elseif isstruct(DIRS)
    dropVectors = DIRS;
end
% figure size 400x250
Fig = figure('Position',[100 100 400 250]);
Fig.PaperPositionMode = 'auto';

hold on

% figure name prefix
Fig.Name = 'scatter displacement - ';
for i = 1:S(1)
    % sort according to drop radius
    [sortedRadius{i},Isort] = sort([dropVectors(i,:).dropRadius]);
    sortedDisplacement{i} = dropVectors(i,:).blobDistanceMinusPlus(1,Isort);
    Ilim = (sortedRadius{i}*2 >= Lmin) & (sortedRadius{i}*2 <= Lmax);
    sortedRadius{i} = sortedRadius{i}(Ilim);
    sortedDisplacement{i} = sortedDisplacement{i}(Ilim);
    % calculate gaussian and average
%     sigma = 5;
    
    di = repmat(sortedDisplacement{i},length(sortedDisplacement{i}),1);
    
    [ri,r0] = meshgrid(sortedRadius{i},sortedRadius{i});
    r = ri - r0;
    expo = exp(-(r.^2)/(2*sigma));
    norm = sum(expo);
    avg = sum(di'.*expo)./norm;
    
    % plot
    blobDistanceMinusPlus =[dropVectors(i,:).blobDistanceMinusPlus];
    rN = blobDistanceMinusPlus(1,:)./[dropVectors(i,:).dropEffectiveRadius];
     displacement_scatter(i) = plot([dropVectors(i,:).dropRadius] * 2, blobDistanceMinusPlus(1,:),'.','LineStyle','none','MarkerSize', 14);

    if plotAvg
        % plot average symmetry breaking
        currentColorIndex = get(gca, 'ColorOrderIndex');
        set(gca, 'ColorOrderIndex', currentColorIndex - 1);
        displacement_plot(i) = plot(sortedRadius{i}*2,avg,'linewidth',2);
        
        % string to dispaly in legend
        displacement_plot(i).DisplayName = dropVectors(i,1).description;
    else
        displacement_scatter(i).DisplayName = dropVectors(i,1).description;
    end
    legend('off');
    % add description to figure name
    Fig.Name = [Fig.Name, dropVectors(i,1).description];
    if i<S(1)
        Fig.Name = [Fig.Name, ', '];
    elseif exist('append','var')
        Fig.Name = [Fig.Name, append];
    end
end

xlabel('Drop Diameter [{\mu}m]');
ylabel('Displacement [{\mu}m]','FontSize',8);
xlim([Lmin,Lmax]);

yl = [0,Lmax/2];
ylim(yl);
ax = gca;
ax.YTick = 0:30:yl(2);
ax.XTick = 0:30:Lmax;
ax.FontSize = 8;
ax.LabelFontSizeMultiplier = 1;

% plot drop radius and effective radius
plot(Lmin:Lmax , (Lmin:Lmax) / 2,'k--');
plot(Lmin:Lmax , (Lmin:Lmax)*(1-(0.7^2/15/2)^(1/3)) / 2,'r--');
% plot vertical setion lines
if exist('sectionLines','var') && sectionLines(1) > 0
    hold on
    for sl=1:size(sectionLines,1)
        y = 1:sectionLines(sl,2);
        x = sectionLines(sl,1) * ones(size(y));
        plot(x,y,'b:', 'LineWidth',1);
    end
end
hold off
% h = legend(displacement_plot,'location','best');
if plotAvg
    uistack(displacement_plot,'top');
    h = legend(displacement_plot,'location','best');
else
     h = legend(displacement_scatter,'location','best');
end
h.Box ='off';
if iscellstr(DIRS)
    print(Fig,fullfile(DIRS{1},[Fig.Name,'.eps']),'-depsc');
end
end