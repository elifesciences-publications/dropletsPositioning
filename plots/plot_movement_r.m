function Fig = plot_movement_r(DIRS)
% PLOT_MOVEMENT_R
% function Fig = plot_movement_r(DIRS)
% plot blob distance from drop center in 3d as a funtion of time
%
% Input:
% DIRS       cell array of data directories, columns will be loaded together and
% plotted in a different color.
%
% Output:
% Fig       Figure handle.

% read data
% S = size(DIRS);
% 
fields={'blobDistanceMinusPlus','times','dropRadius','dropEffectiveRadius'};
dropVectors = loadDropsVectors(DIRS,fields,true);
DIR=DIRS{1};
blobDistanceMinusPlus = dropVectors.blobDistanceMinusPlus;
times = dropVectors.times;
dropRadius = dropVectors.dropRadius;
dropEffectiveRadius = dropVectors.dropEffectiveRadius;

% blobDistanceMinusPlus = dlmread(fullfile(DIR,'blobDistanceMinusPlus'));
% times = dlmread(fullfile(DIR,'times'));
% dropRadius = dlmread(fullfile(DIR,'dropRadius'));
% dropEffectiveRadius = dlmread(fullfile(DIR,'dropEffectiveRadius'));

% figure size 500x350
Fig = figure('Position',[100 100 500 350]);
Fig.PaperPositionMode = 'auto';
hold on

% plot blob distances
s = errorbar(times, blobDistanceMinusPlus(1,:),abs(blobDistanceMinusPlus(2,:)), blobDistanceMinusPlus(3,:),'.');

% plot drop radius and effective radius
plot(times , ones(size(times))*dropRadius(1),'k--');
plot(times , ones(size(times))*dropEffectiveRadius(1),'r--');
ax = gca;
ax.FontSize = 16;
legend('off');
xlabel('time [s]');
ylabel('Displacement [{\mu}m]');
xlim([times(1),times(end)]);
ylim([0,35]); % CHANGE ACCORDING TO DATA!
title(sprintf('D=%d {\\mu}m',round(mean(dropRadius)*2)));
% save figure
print(Fig,fullfile(DIR,'r_movement.eps'),'-depsc');
