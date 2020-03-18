DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\nocadazole\2019_10_27 33uM nocadazole mix1 sample1';
DIR = 'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\100nM ActA\2019_10_28\mix1';

fileList = string(ls(fullfile(DIR, '*.mat')));

clear droplets
for fileInd = 1:numel(fileList)
    filename = fullfile(DIR, fileList(fileInd));
    load(filename);
    droplets = fixDropletsTimes(droplets, 15*60);
    save(filename,'droplets','-v7.3');
end
%%
% matDIR = {'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix5 0.05uM acta-bodipy\',...
%     'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix4 0.025uM acta-bodipy\',...
%     'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_31 mix1 0.017uM acta-bodipy\'};
% 
% for dirNum = 1:length(matDIR)
%     clear matFilenames
%     matFs = ls(fullfile(matDIR{dirNum},'*.mat'));
%     for i=1:size(matFs,1)
%         clear droplets
%         matFilenames{i} = fullfile(matDIR{dirNum},matFs(i,:));
%         d = load(matFilenames{i});
%         for j=1:length(d.droplets)
%             if d.droplets(j).time == 0;
%                 d.droplets(j).time = 900;
%             end
%         end
%         droplets = d.droplets;
%         save(matFilenames{i},'droplets','-v7.3');
%     end
% end
matDIR = {'W:\phkinnerets\storage\analysis\Niv\rambam5 extract\symmetry breaking analysis\acta-bodipy\2018_12_30 mix3 0.1uM acta-bodipy\'};
for dirNum = 1:length(matDIR)
    clear matFilenames
    matFs = ls(fullfile(matDIR{dirNum},'*.mat'));
    for i=1:size(matFs,1)
        clear droplets
        matFilenames{i} = fullfile(matDIR{dirNum},matFs(i,:));
        d = load(matFilenames{i});
        for j=1:length(d.droplets)
            if d.droplets(j).time == 0 || isnan(d.droplets(j).time)
                d.droplets(j).time = 900;
            end
        end
        droplets = d.droplets;
        save(matFilenames{i},'droplets','-v7.3');
    end
end
