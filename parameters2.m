[PARAMS(1,1,1:3).dirs] = deal(struct('name',{'Z:/analysis/Niv/montages/2016_06_20/80P_24c'}));
[PARAMS(1,1,1:3).percent] = deal(80);
[PARAMS(1,1,1:3).temp] = deal(24);

[PARAMS(1,2,1:3).dirs] = deal(struct('name',{'Z:/analysis/Niv/montages/2016_06_07/80P_30c'}));
[PARAMS(1,2,1:3).percent] = deal(80);
[PARAMS(1,2,1:3).temp] = deal(30);

[PARAMS(2,1,1:3).dirs] = deal(struct('name',{'Z:/analysis/Niv/montages/2016_07_05/40P_BSA-beads_24c',...
    'Z:/analysis/Niv/montages/2016_07_12/40P_BSA-beads_24c',...
    'Z:/analysis/Niv/montages/2016_07_13/40P_BSA-beads_24c'}));
[PARAMS(2,1,1:3).percent] = deal(40);
[PARAMS(2,1,1:3).temp] = deal(24);

[PARAMS(2,2,1:3).dirs] = deal(struct('name',{'Z:/analysis/Niv/montages/2016_07_05/40P_BSA-beads_30c',...
    'Z:/analysis/Niv/montages/2016_07_13/40P_BSA-beads_30c'}));
[PARAMS(2,2,1:3).percent] = deal(40);
[PARAMS(2,2,1:3).temp] = deal(30);
[PARAMS([PARAMS.percent] == 80).blobRfactor] = deal((0.7^2/15)^(1/3));
[PARAMS([PARAMS.percent] == 40).blobRfactor] = deal(0.1);
basename = 'analysis_data_';
times = [0,30,60];

for i=1:size(PARAMS,1)
    for j = 1:size(PARAMS,2)
        for k = 1:size(PARAMS,3)
            for l = 1:length(PARAMS(i,j,k).dirs)
                T = readtable(fullfile(PARAMS(i,j,k).dirs(l).name,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
                filename_suffix = table2cell(T(k,end));
                PARAMS(i,j,k).dirs(l).filename = [basename,filename_suffix{1}];
                PARAMS(i,j,k).time = times(k);
            end
        end
    end
end