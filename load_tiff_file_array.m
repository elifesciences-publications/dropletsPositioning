function image_stack = load_tiff_file_array(filename, scalefactor, type)
    if ~exist('type', 'var')
        type = 'double';
    end
    t = Tiff(filename);
    tiffInfo = imfinfo(filename);
    image_stack = zeros(tiffInfo(1).Height,tiffInfo(1).Width,length(tiffInfo), 'uint16');
    for k = 1:length(tiffInfo)
        t.setDirectory(k);
        image_stack(:,:,k) = imresize(t.read(),scalefactor);
    end
    t.close();
end