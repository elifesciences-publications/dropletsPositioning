% DIR = 'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample1';
% name = 'analysis_data_montage40m.mat';
% newFilename = convert_to_oop(fullfile(DIR,name))

D = rdir('Z:\analysis\Niv\adams visit\symmetry breaking analysis\**\analysis_data*.mat')
i=1;
while i <= length(D)
    if ~isempty(strfind(D(i).name,'auto')) || ~isempty(strfind(D(i).name,'oop'))
        D(i) = [];
    else 
        i = i+1;
    end
end
D
Dnew = cell(size(D));
for j=1:numel(D)
    Dnew{j} = convert_to_oop(D(j).name);
end
Dnew