function OUT_DATA = data_convert(IN_DATA)
    if isstruct(IN_DATA.drops)
        OUT_DATA = IN_DATA;
    else
        OUT_DATA.PAR = IN_DATA.PAR;
        OUT_DATA.drops = struct('images',IN_DATA.drops,'radius',IN_DATA.radius,...
            'center',cellfun(@(x) round(size(x{1})/2),IN_DATA.drops,'UniformOutput',false),...
            'plainsPerPixel',IN_DATA.plainsPerPixel,'micronsPerPixel',IN_DATA.micronsPerPixel,...
            'centerPlain', num2cell(IN_DATA.centerPlains'),'blobs',IN_DATA.blobs,...
            'blobPlains',num2cell(IN_DATA.blobPlains'),'blobCenters',IN_DATA.blobCenters);
    end
    for i = 1:length(OUT_DATA.drops)
        if OUT_DATA.drops(i).blobPlains == 0;
            OUT_DATA.drops(i).blobPlains = [];
        end
        if OUT_DATA.drops(i).centerPlain == 0;
            OUT_DATA.drops(i).centerPlain = [];
        end
    end
end