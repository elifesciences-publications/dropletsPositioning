function image_stack = load_tiff_file(filename, scalefactor)
t = Tiff(filename);
tiffInfo = imfinfo(filename);
image_stack = cell(1,length(tiffInfo));
for k = 1:length(tiffInfo)
    t.setDirectory(k);
    image_stack{k} = imresize(t.read(),scalefactor);
end
t.close();
end
