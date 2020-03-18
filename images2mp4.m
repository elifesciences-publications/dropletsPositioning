function MovieArray = images2mp4(Filename)
%Filename = 'C:\Users\Nivieru\Documents\waves\2017_03_30\rambam7+LA-GFP\waves_with_annotations.tif';
[Dir, Name, Ext] = fileparts(Filename);
if (strcmp(Ext,'.tif') || strcmp(Ext,'.tiff'))
    tiff_movie = load_tiff_file(Filename,1);
    for i=1:length(tiff_movie)
        MovieArray(:,:,:,i) = double(tiff_movie{i});
    end
    MovieArray = MovieArray./max(MovieArray(:));
elseif strcmp(Ext,'.gif')
    MovieArray=imread(Filename,'frames','all');
else
    error('filetype not supported');
end
VideoFileName = fullfile(Dir,[Name,'.mp4']);
PosterFileName = fullfile(Dir,[Name,'-poster.png']);
v = VideoWriter(VideoFileName,'MPEG-4');
display(sprintf('Writing video to file %s', VideoFileName));
v.FrameRate = 5;
open(v)
writeVideo(v,MovieArray);
close(v)
poster_image = MovieArray(:,:,:,1);
display(sprintf('Writing poster to file %s', PosterFileName));
imwrite(poster_image,PosterFileName);
end
