function Fig = peakActinDensity_paper()
    load('W:\phkinnerets\storage\analysis\Maya\PhD Analysis\Maya Analysis after GRC\Data Analysis\Actin & LA labeling\DROPS.mat');
    stdCondDrops = DROPS([DROPS.typeOfExp] == 100);
    for i=1:numel(stdCondDrops)
        M(i) = (max(stdCondDrops(i).Rh_Rho) - stdCondDrops(i).Rh_background).*stdCondDrops(i).RhcalibrationNum;
    end
    Fig = figure('Position', [100,100,300,200]);
    scatter([stdCondDrops.DropSize], M,30,'o','filled');
    ax = gca;
    ax.YTick = [];
    xl = xlim;
    xlim([0,xl(2)]);
    
    xlabel('Drop radius [um]');
    ylabel('peak actin density [A.U.]');
end