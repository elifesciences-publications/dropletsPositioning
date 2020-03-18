function DATA = run_montage_analysis(varargin)
PAR = varargin{1};
AUTODATA = emulsion_auto_analysis(varargin{:});
DATA = emulsions_gui(AUTODATA);
save(fullfile(PAR.DIRNAME,'analysis_data.mat'),'DATA','-v7.3'),
emulsion_hist(DATA);
hasBlob = NaN(size(DATA.drops));
hasPlain = NaN(size(DATA.drops));
for i=1:length(DATA.drops)
    if ~isempty((DATA.drops(i).centerPlain)
        hasPlain(i) = DATA.drops(i).radius(DATA.drops(i).centerPlain);
        if ~isempty(DATA.drops(i).blobPlains(i))
            hasBlob(i) = hasPlain(i);
        end
    end
end
figure; hist([hasBlob;hasPlain]'*DATA.micronsPerPixel)
