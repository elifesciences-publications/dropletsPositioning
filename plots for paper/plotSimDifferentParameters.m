%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DYNAMIC PLOT - Parameter variations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load data
load('data_dynAgg_varyVisc_vTimePosSpeed.mat')
vAggPos_varyVisc=vAggPos_all;
vAggSpeed_varyVisc=vAggSpeed_all;

load('data_dynAgg_varyAlpha_vTimePosSpeed.mat')
vAggPos_varyAlpha=vAggPos_all;
vAggSpeed_varyAlpha=vAggSpeed_all;

load('data_dynAgg_varyBeta_vTimePosSpeed.mat')
vAggPos_varyBeta=vAggPos_all;
vAggSpeed_varyBeta=vAggSpeed_all;

load('data_dynAgg_varyGamma_vTimePosSpeed.mat')
vAggPos_varyGamma=vAggPos_all;
vAggSpeed_varyGamma=vAggSpeed_all;

% clear unnecessary variables
clear vAggPos_all
clear vAggSpeed_all

%% Plot
FigSimParams = figure('Position',[100 100 1000 200]);

subplot(1,4,1)
    plot(vTime, vAggPos_varyVisc ,'LineWidth',2)
    legend({strcat('u=', num2str(viscVals(1:2:end)','%.2e'), ' (pN min/um^2)')}, 'location', 'northeast')
    xlabel('time (min)'); ylabel('displacement (um)')
    title('vary viscosity')
    set(gca, 'FontSize',fs)
        
subplot(1,4,2)
    plot(vTime, vAggPos_varyAlpha ,'LineWidth',2)
    legend({strcat('a=', num2str(alphaVals(1:2:end)',2), ' (uM/min)')}, 'location', 'northeast')
    xlabel('time (min)'); ylabel('displacement (um)')
    title('vary actin binding rate')
    set(gca, 'FontSize',fs)
    
subplot(1,4,3)
    plot(vTime, vAggPos_varyBeta(1:2:end,:) ,'LineWidth',2)
    legend({strcat('b=', num2str(betaVals(1:2:end)',2), ' (1/min)')}, 'location', 'northeast')
    xlabel('time (min)'); ylabel('displacement (um)')
    title('vary actin unbinding rate')
    set(gca, 'FontSize',fs)
    
subplot(1,4,4)
    plot(vTime, vAggPos_varyGamma(1:2:end,:) ,'LineWidth',2)
    legend({strcat('k=', num2str(gammaVals(1:2:end)',2), ' (1/min)')}, 'location', 'northeast')
    xlabel('time (min)'); ylabel('displacement (um)')
    ylim([0 35])
    title('vary contraction rate')
    set(gca, 'FontSize',fs)
    %%
    if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
        print(FigSimParams,fullfile(outputDir,'simDifferentParams'),format);
    end