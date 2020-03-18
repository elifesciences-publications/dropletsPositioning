function [ filename, image ] = load_tiff_file_num_plane( dirname , scaleFactor, num, plane, varargin)
% load all tiffs from direrctory <dirname> into stack.
% scale images by scaleFactor.
FILTER = cell(1,max(length(varargin),1));
if nargin > 2
    for i = 1:length(varargin)
        FILTER{i} = varargin{i};
    end
else
    FILTER{1} = '*.tiff';
end
k=0;
for i = 1:length(FILTER)
    D = dir(fullfile(dirname,FILTER{i}));
    fs = {D.name};
    for j=1:length(fs);
        k = k+1;
        if k == num
            filename = fullfile(dirname,fs{j});
            t = Tiff(filename);
            % tiffInfo = imfinfo(filename);
            t.setDirectory(plane);
            image = imresize(t.read(),scaleFactor);
            t.close();
            return
        end
    end
end
end
