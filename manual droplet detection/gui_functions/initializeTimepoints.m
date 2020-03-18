function timepoint = initializeTimepoints(numOfTimepoints, filenames, images)
for i=1:numOfTimepoints
    if exist('images','var') && size(images,2) >= i
        if iscell(images{1,i,1})
            timepoint(i).images = reshape(images{:,i,:}, numel(images{:,i,1}), []);
        else
            timepoint(i).images = reshape(images(:,i,:), numel(images(:,i,1)), []);
        end
    else
        timepoint(i).images = load_tiff_file(filenames{i},1);
    end
    timepoint(i).droplets = emptyDroplet;
    if numel(filenames) == 1
        timepoint(i).filename = filenames{1};
    elseif numel(filenames) == numOfTimepoints
        timepoint(i).filename = filenames{i};
    else
        warning('filenames size does not match number of timepoints or 1');
    end
end