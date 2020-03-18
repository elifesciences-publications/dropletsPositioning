timepoints = 1;
matDIR = {'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix3 0.1uM acta-bodipy\',...
    'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix5 0.05uM acta-bodipy\',...
    'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix4 0.025uM acta-bodipy\',...
    'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_31 mix1 0.017uM acta-bodipy\'};

% matDIR = {'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix5 0.05uM acta-bodipy\',...
%     'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix4 0.025uM acta-bodipy\',...
%     'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_31 mix1 0.017uM acta-bodipy\'};

clear allDroplets droplets;
for dirNum = 1:length(matDIR)
    clear matFilenames
    allDroplets{dirNum} = [];
    matFs = ls(fullfile(matDIR{dirNum},'*.mat'));
    for i=1:size(matFs,1)
        matFilenames{i} = fullfile(matDIR{dirNum},matFs(i,:));
        d = load(matFilenames{i});
        addDroplets = [];
        for j=1:length(d.droplets)
            if ~isempty(d.droplets(j).aggregatePlane)
                addDroplets = [addDroplets, d.droplets(j)];
            end
        end
        if isempty(addDroplets)
            continue;
        end
        allDroplets{dirNum} = [allDroplets{dirNum},addDroplets];
    end
end

% tzone = [50,90]; %initial time transition zone;
% tzone = [60,85]; %standard condition transition zone;
% seperators = [tzone(1),50;tzone(2),50];
descriptions = {'0.1uM acta-bodipy', '0.05uM acta-bodipy', '0.025uM acta-bodipy', '0.017uM acta-bodipy'};
% descriptions = {'0.05uM acta-bodipy', '0.025uM acta-bodipy', '0.017uM acta-bodipy'};

for dirNum = 1:length(allDroplets)
    droplets = allDroplets{dirNum};
    ts = round([droplets.time]/60);
    TU = unique(ts);
    for tp=timepoints
        T = TU(tp);
        ind = find(ts == T);
        dropVectors(dirNum,1) = makeDropVectors(droplets(ind), sprintf('%s ,T=%d-%d',descriptions{dirNum}, T, T+5));
        [Fig(dirNum), sectionsActABodipy(tp,:, dirNum)] = scatter_displacement_paper2(dropVectors(dirNum),true,[nan; nan], format, outputDir);
    end
    %     histFig(i,:) = hist_symbreaking_paper(dropVectors(i),tzone);
end

conc = [0.1, 0.05, 0.025, 0.017];
% conc = [0.05, 0.025, 0.017];

[concSorted,sortConcInd] = sort(conc);
concSorted = [0, concSorted];
for t = timepoints
    FigTransitionRangeActABodipy(t) = figure('Position',[100 100 250 250]);
    FigTransitionRangeActABodipy(t).PaperPositionMode = 'auto';
%     hold on
    ax = gca;
%     plot([0,0],sectionsTime(t,:)','b', 'lineWidth', 2);
%     for s = 1:2
%         plot([conc(s),conc(s)],sectionsActABodipy(t,:,s)','b', 'lineWidth', 2);
    sectionsActABodipySorted = sectionsActABodipy(:,:,sortConcInd);
    sectionsActABodipySorted(isnan(sectionsActABodipySorted)) = 60;
    secs = [sectionsTime(t,:);squeeze(sectionsActABodipySorted(t,:,:))'];
    secs(:,3) = 60;
    secs(:,2:3) = diff(secs,1,2);
%     h = area(concSorted([1,3:4]),secs([1,3:4],:));
    h = area(concSorted([1,3:end]),secs([1,3:end],:));
    h(1).FaceColor = [253,226,226]./256;
    
    h(2).FaceColor = [255,239,202]./256;
    h(3).FaceColor = [233,243,221]./256;
    ylim([30,60]);
    xlim(concSorted([1,length(concSorted)]));
    ax.XTick = concSorted([1,3:4]);
%     end
    xlabel('ActA-bodipy concentration [uM]');
    ylabel('Transition size range [um]');
    title(sprintf('Time = %d-%d min',TU(t), TU(t)+5));
end
if exist('format','var') && ischar(format) && exist('outputDir', 'var') && ischar(outputDir)
    for t=timepoints
        print(FigTransitionRangeActABodipy(t),fullfile(outputDir,['FigTransitionRangeActABodipy_',num2str(TU(t))]),format);
    end
end

