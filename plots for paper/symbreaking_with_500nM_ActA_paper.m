timepoints = 1; % I only analysed the third time point, so 1 is the third.
matDIR = {'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\0.5uM ActA\2020_01_08\sample1'};
clear allDroplets droplets dropVectors;
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
descriptions = {'ActA'};

for dirNum = 1:length(allDroplets)
    droplets = allDroplets{dirNum};
%     ts = round([droplets.time]/60);
%     TU = unique(ts);
        dropVectors(dirNum,1) = makeDropVectors(droplets, sprintf('%s ,T=%d-%d',descriptions{dirNum}, 40, 45));
        [Fig(dirNum), ~] = scatter_displacement_paper2(dropVectors(dirNum),true,sectionLines, format, outputDir);
%     end
end

