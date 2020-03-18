function DATA = find_drops_in_montage(DIR, LINE)
plain = 2;
fn = fullfile(DIR,'params.txt')
PAR = read_par(fn);
T = readtable(fullfile(DIR,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
NAME = table2cell(T(LINE,end));
PAR.NAME = NAME{1};

DATA = load([fullfile(DIR,'analysis_data_'),PAR.NAME]);
fs = fieldnames(DATA);
if length(fs) == 1
    DATA = getfield(DATA,fs{1});
end
load(fullfile(DIR,DATA.PAR.NAME));
bigPicture = Montage{plain};
for dropNum = 1:length(DATA.drops)
    display(sprintf('drop number %d',dropNum));
    smallPicture = DATA.drops(dropNum).images{plain};
    location = find_subimage(smallPicture, bigPicture);
    DATA.drops(dropNum).location = location;
    Sh = floor(size(smallPicture)/2);
    rows = max(1, location(1)-Sh(1)): min(size(bigPicture,1), location(1)+Sh(1));
    cols = max(1, location(2)-Sh(2)): min(size(bigPicture,2), location(2)+Sh(2));
    extracted{dropNum} = bigPicture(rows,cols);
end
save([fullfile(DIR,'analysis_data_with_loaction_'),PAR.NAME],'DATA','-v7.3');
save([fullfile(DIR,'extracted_images_'),PAR.NAME],'extracted','-v7.3');
display('done');

end
