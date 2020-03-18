function Fig = plot_vvcorr(DIRS,delta,factor)
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

fields={'blobXYZ','times','dropRadius'};
dropVectors = loadDropsVectors(DIRS',fields,true);
S = size(DIRS);
Fig = figure('Position',[100 100 500 590]);
Fig.PaperPositionMode = 'auto';

hold on

for i = 1:S(1)

XYZ = dropVectors(i).blobXYZ;
t = dropVectors(i).times;
dropRadius = dropVectors(i).dropRadius;

% XYZ = dlmread(fullfile(DIR,'blobXYZ'));
% times = dlmread(fullfile(DIR,'times'));
% dropRadius = dlmread(fullfile(DIR,'dropRadius'));

% use subtightplot function instead of subplot
% figure size 500x590

x = XYZ(1,:);
y =  XYZ(2,:);
% MSD subplot
[VVcorr, stdVV] = vel_vel_corr(x,y,t,delta,factor); %calculate MSD up to differance of 1/6 of total time
f(i) = scatter(t(1:length(VVcorr)),VVcorr,'.');
% f(i) = errorbar(times(1:length(VVcorr)),VVcorr,stdVV,'.');

end
% xlabel('log \Delta t','FontSize',14);
% xlim([times(1),times(length(msdVec))]);
% ylabel('log MSD','FontSize',14);
% legend(f,sprintf('slope: %.2f \\pm %.2f',fit.Coefficients.Estimate(2)...
%     ,fit.Coefficients.SE(2)));
% hold off
% 
% % save figure
% print(Fig,fullfile(DIR,'xy_movement.eps'),'-depsc');
end
