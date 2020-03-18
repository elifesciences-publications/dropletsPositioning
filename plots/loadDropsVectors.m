function dropsVectors = loadDropsVectors(DIRS,fields,cat)
dropsVectors = [];
dropsVectorsCat = [];
S = size(DIRS);
for i=1:S(1)
    for j=1:S(2)
        if ~isempty(DIRS{i,j})
            %             if exist('cat','var') && cat
            %             FID = fopen(fullfile(DIRS{i,j},'description'),'r');
            %             dropsVectors(i).description = fscanf(FID,'%s');
            %             fclose(FID);
            %             for f=1:numel(fields)
            %                 dropsVectors = setfield(dropsVectors,{i},fields{f}, [getfield(dropsVectors,{i}),dlmread(fullfile(DIRS{i,j},fields{f}))]);
            %             end
            %             else
            FID = fopen(fullfile(DIRS{i,j},'description'),'r');
            description_cell = textscan(FID, '%s', 'delimiter', '\n', 'whitespace', '');
            dropsVectors(i,j).description = description_cell{1}{1};
            fclose(FID);
            for f=1:numel(fields)
                dropsVectors = setfield(dropsVectors,{i,j},fields{f}, dlmread(fullfile(DIRS{i,j},fields{f})));
            end
            %             end
        end
    end
end
if exist('cat','var') && cat
    for j=1:S(2)
        dropsVectorsCat(j).description = dropsVectors(1,j).description;
        for f=1:numel(fields)
            dropsVectorsCat(j).(fields{f}) = [dropsVectors(:,j).(fields{f})];
        end
    end
    dropsVectors = dropsVectorsCat;
end
