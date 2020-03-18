function Fig = plot_movement_xy(DIRS,zoom,offset)
% PLOT_MOVEMENT_XY
% function Fig = plot_movement_xy(DIRS,zoom)
% plot blob track in x-y directions, and MSD of the movement
%
% Input:
% DIRS       cell array of data directories, columns will be loaded together and
% plotted in a different color.
% zoom      Zoom factor for the track plot.
%           Sets axis limits to dropRadius/zoom.
%           Use higer zoom for smaller movem
%
% Output:
% Fig       Figure handle.


% default zoom = 1;
if ~exist('zoom','var')
    zoom = 1;
end
if ~exist('offset','var')
    offset = [0,0];
end
if length(offset) < 2
    offset(2) = offset(1);
end
% read data
% S = size(DIRS);
% 
fields={'blobXYZ','times','dropRadius'};
dropVectors = loadDropsVectors(DIRS,fields,true);
DIR=DIRS{1};
XYZ = dropVectors.blobXYZ;
times = dropVectors.times;
dropRadius = dropVectors.dropRadius;

% XYZ = dlmread(fullfile(DIR,'blobXYZ'));
% times = dlmread(fullfile(DIR,'times'));
% dropRadius = dlmread(fullfile(DIR,'dropRadius'));

% use subtightplot function instead of subplot
%subplot = @(M,N,P) subtightplot(M,N,P,[0.1,0.1],[0.1,0.08],[0.14,0.06]);

% figure size 500x590
Fig = figure('Position',[100 100 500 300]);
Fig.PaperPositionMode = 'auto';
hold on

x = XYZ(1,:);
y =  XYZ(2,:);
col = times;
lim = dropRadius(1)/zoom;

colormap('copper');
surface([x;x],[y;y],[col;col],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',1);
c = colorbar;
c.FontSize = 16;

c.Ticks = [1,max(times)];
c.TickLabels = {'0', [num2str(c.Ticks(end)),' seconds']};
c.Label.String = 'time';
%c.Label.FontSize = 16;

xlim([-lim,lim] + offset(1));
ylim([-lim,lim] + offset(2));
% xlabel('x [microns]','FontSize',14);
% ylabel('y [microns]','FontSize',14);
axis equal
axis off
scalebar('XLen',1,'YLen',1, 'XUnit', 'um', 'Border', 'LN', 'FontSize', 16);
title(sprintf('D=%d {\um}m',round(mean(dropRadius) * 2)));

print(Fig,fullfile(DIR,'xy_track.eps'),'-depsc');
end
