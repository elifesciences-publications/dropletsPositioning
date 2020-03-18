load('W:\phkinnerets\storage\analysis\Maya\PhD Analysis\Maya Analysis after GRC\Data Analysis\Actin & LA labeling\DROPS.mat');
inds = find([DROPS.DropSize] > 55 & [DROPS.typeOfExp] == 100);
TypeOfLabel=importdata('W:\phkinnerets\storage\analysis\Maya\PhD Analysis\Maya Analysis after GRC\Data Analysis\Intensity Correction\2017_03_23\80% extract CP actin and LA\Mix1 12_50\Montage images only frames far from the egde\TypeOfLabel.mat');
RhCalibration1uM = mean(TypeOfLabel(2).IntensityMatrix(:));
% RhCalibration1uM = 3.3705e+04; % from: 'W:\phkinnerets\storage\analysis\Maya\PhD Analysis\Maya Analysis after GRC\Data Analysis\Intensity Correction\2017_03_23\80% extract CP actin and LA\Mix1 12_50\Montage images only frames far from the egde\TypeOfLabel.mat'
actinCalibration1uM = RhCalibration1uM/18; %total actin concentracion is 18uM, 1uM is labeld

FigActinDensity = figure('Position',[200,200,700,250]);
subplot(1,2,1);
hold on;
for d=1:numel(inds)
    i = inds(d);
    r = DROPS(i).Rh_Rrho;
    imagingCal = 1; % DROPS(i).RhcalibrationNum;
    rho = (DROPS(i).Rh_Rho - DROPS(i).Rh_background)*imagingCal/actinCalibration1uM;
    plot(r, rho);
    peakI(d) = max(rho);
end
xlabel('r [um]');
ylabel('Actin network density [uM]');
xlim([0,160]);
% ylim([-1,4]);

subplot(1,2,2);
Rs = [DROPS(inds).DropSize];
scatter(Rs, peakI);
xlabel('Drop radius [um]');
ylabel('Peak actin density [uM]');

if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    FigActinDensity.PaperPositionMode = 'auto';
    print(FigActinDensity,fullfile(outputDir,'actin_density'),format);
end


