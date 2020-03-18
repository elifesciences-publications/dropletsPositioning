load(fLoad)

t = num2cell(15:15:60);
tp = num2cell(1:4);
tInd = [1:4];
[droplets.time] = deal(t{tInd})
[droplets.timepoint] = deal(tp{tInd})
[droplets.filename] = deal(filenames{tInd})

% [droplets([1:3,5]).time] = deal(15,30,45,60)
% [droplets([1:3,5]).timepoint] = deal(1,2,3,4)
% [droplets([1:3,5]).filename] = deal(filenames{:})

% [droplets.time] = deal(15,30,30,45,45,60,60)
% [droplets.timepoint] = deal(1,2,2,3,3,4,4)
% [droplets.filename] = deal(filenames{[1,2,2,3,3,4,4]})

% [droplets.time] = deal(30,45,60)
% [droplets.timepoint] = deal(2,3,4)
% [droplets.filename] = deal(filenames{2:4})
% 
% [droplets.time] = deal(15,30,45,60)
% [droplets.timepoint] = deal(1,2,3,4)
% [droplets.filename] = deal(filenames{:})

save(fLoad,'droplets')
one_position_gui_obj(filenames, images, fLoad)