function [dropletPosition,aggregatePosition] = ManualTrackMovie(Filename)
[Dir,Name,Ext] = fileparts(Filename);
if ~strcmp(Ext,'.tiff') && ~strcmp(Ext,'.tif')
    error('Not a tiff file')
end
images = load_tiff_file(Filename,1);
for i = 1:length(images)
    imshow(images{i});
   
    title('Circle droplet')
    if i == 1
    	hd = imellipse(gca);
    else
        hd = imellipse(gca,dropletPosition(i-1,:));
    end
    vert=wait(hd);
    dropletPosition(i,:)=getPosition(hd);
    
    title('Circle aggregate')
    if i == 1
    	ha = imellipse(gca);
    else
        ha = imellipse(gca,aggregatePosition(i-1,:) + dropletPosition(i,:) - dropletPosition(i-1,:));
    end
    vert=wait(ha);
    aggregatePosition(i,:)=getPosition(ha);
end
save(fullfile(Dir,[Name,'_dropletPosition.txt']),'dropletPosition','-ascii');
save(fullfile(Dir,[Name,'_aggregatePosition.txt']),'aggregatePosition','-ascii');
end