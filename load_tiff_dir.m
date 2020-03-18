function [ stack ] = load_tiff_dir( dirname , scaleFactor, varargin)
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
stack = struct('filename',{},'planes',{});
for i = 1:length(FILTER)
D = dir(fullfile(dirname,FILTER{i}));
    fs = {D.name};
    for j=1:length(fs);
        tfile = fullfile(dirname,fs{j});
        stack(i,j).filename = tfile;
%         t = Tiff(tfile);
%         inf = imfinfo(tfile);
%         for k = 1:length(inf)
%             t.setDirectory(k);
%             stack(i,j).planes{k} = imresize(t.read(),scaleFactor);
%         end
%         t.close();
        stack(i,j).planes = load_tiff_file(tfile,scaleFactor);
    end
end
