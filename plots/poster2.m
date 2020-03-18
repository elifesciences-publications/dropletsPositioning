scale = 0.5;
dropScale = 0.5;
relScale = dropScale/scale;
micronsPerPixel = 0.1557 / scale;
micronsPerPlane = 5;
%% abp1Srv2
DIR = 'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_07\Srv2_2muM+Abp1_2muM\'
stack = load_tiff_dir(DIR,scale,'*T2_C0.tiff');

Rads = [AbpSrv.DATA.drops.radius] * AbpSrv.DATA.drops(1).micronsPerPixel;
Ind(1) = find(Rads < 49 & Rads > 48.9)
Ind(2) = find(Rads < 45.07 & Rads > 45.06)
Ind(3) = find(Rads < 42.49 & Rads > 42.48)
Ind(4) = find(Rads < 37.67 & Rads > 37.66)
Ind(5) = find(Rads < 17.34 & Rads > 17.33)
Ind(6) = find(Rads < 17.12 & Rads > 17.11)

k=4;
[i,j] = ind2sub(size(Rads),Ind(k));
drop = AbpSrv.DATA.drops(j);
xmin = drop.location(2)/relScale - 60/micronsPerPixel;
ymin = drop.location(1)/relScale - 60/micronsPerPixel;

for m = 1:numel(stack)
    figure;
    I = imadjust(imcrop(stack(m).planes{i},[xmin,ymin,60*2/micronsPerPixel,60*2/micronsPerPixel]));
    imshow(I);
end
Ms = [23,27,28,25,22,27];
for k = 1:length(Ind)
    [i,j] = ind2sub(size(Rads),Ind(k))
    drop = AbpSrv.DATA.drops(j)
    [ filename{k}, image{k} ] = load_tiff_file_num_plane(DIR,scale, Ms(k), i,'*T2_C0.tiff');
    RGB{k} = miniImage(image{k},drop,micronsPerPixel,relScale);
end
L = ceil(60*2/micronsPerPixel);
poster = zeros([L*2 + 1,L*3 + 1,3]);
for pos_ind = 1:6
    [pos_indx,pos_indy] = ind2sub([3,2],pos_ind);
    Xindices = (1:size(RGB{pos_ind},2)) + (pos_indx - 1)*L;
    Yindices = (1:size(RGB{pos_ind},1)) + (pos_indy - 1)*L;
    if(Xindices(end) <= size(poster,2) && Yindices(end) <= size(poster,1))
        poster(Yindices,Xindices,:) = RGB{pos_ind};
    end
end
figure; imshow(poster);
%%
imwrite(poster,'\\phkinnerets\lab\LabMeetings\niv\data\AbpSrv\poster images\poster.png');
for i = 1:6
    imwrite(image{i},fullfile('\\phkinnerets\lab\LabMeetings\niv\data\AbpSrv\poster images',sprintf('orig_%d.png',i)));
    imwrite(RGB{i},fullfile('\\phkinnerets\lab\LabMeetings\niv\data\AbpSrv\poster images',sprintf('marked_%d.png',i)));
end

%% cca
montageFilename1 = 'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample1 time09_55\montage45m.mat'
montage1 = load(montageFilename1);
Rads = [CCA.DATA(1).drops.radius] * CCA.DATA(1).drops(1).micronsPerPixel;
Ind(1) = find(Rads < 51.2 & Rads > 51.1)
Ind(2) = find(Rads < 43.05 & Rads > 43.04)
Ind(3) = find(Rads < 36.32 & Rads > 36.31)
Ind(4) = find(Rads < 28.45 & Rads > 28.44)
Ind(5) = find(Rads < 19.27 & Rads > 19.26)
Ind(6) = find(Rads < 18.46 & Rads > 18.45)
for k = 1:length(Ind)
    [i,j] = ind2sub(size(Rads),Ind(k))
    drop = CCA.DATA(1).drops(j)
    RGB{k} = miniImage(montage1.Montage{i} ,drop,micronsPerPixel,relScale);
end
L = ceil(60*2/micronsPerPixel);
poster = zeros([L*2 + 1,L*3 + 1,3]);
for pos_ind = 1:6
    [pos_indx,pos_indy] = ind2sub([3,2],pos_ind);
    Xindices = (1:size(RGB{pos_ind},2)) + (pos_indx - 1)*L;
    Yindices = (1:size(RGB{pos_ind},1)) + (pos_indy - 1)*L;
    if(Xindices(end) <= size(poster,2) && Yindices(end) <= size(poster,1))
        poster(Yindices,Xindices,:) = RGB{pos_ind};
    end
end
figure; imshow(poster);
imwrite(poster,'\\phkinnerets\lab\LabMeetings\niv\data\CCA\poster images\poster.png');
for i = 1:6
    imwrite(RGB{i},fullfile('\\phkinnerets\lab\LabMeetings\niv\data\CCA\poster images',sprintf('marked_%d.png',i)));
end

%% acta
montageFilename = 'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP ActA\montage60m.mat';
montage = load(montageFilename);
Rads = [ActA.DATA.drops.radius] * ActA.DATA.drops(1).micronsPerPixel;
%%
Ind(1) = find(Rads < 44.06 & Rads > 44.05)
Ind(2) = find(Rads < 35.65 & Rads > 35.64)
Ind(3) = find(Rads < 32.68 & Rads > 32.67)
Ind(4) = find(Rads < 28.54 & Rads > 28.53)
Ind(5) = find(Rads < 19.5 & Rads > 19.49)
Ind(6) = find(Rads < 17.04 & Rads > 17.03)
for k = 1:length(Ind)
    [i,j] = ind2sub(size(Rads),Ind(k))
    drop = ActA.DATA.drops(j)
    RGB{k} = miniImage(montage.Montage{i} ,drop,micronsPerPixel,relScale);
end
L = ceil(60*2/micronsPerPixel);
poster = zeros([L*2 + 1,L*3 + 1,3]);
for pos_ind = 1:6
    [pos_indx,pos_indy] = ind2sub([3,2],pos_ind);
    Xindices = (1:size(RGB{pos_ind},2)) + (pos_indx - 1)*L;
    Yindices = (1:size(RGB{pos_ind},1)) + (pos_indy - 1)*L;
    if(Xindices(end) <= size(poster,2) && Yindices(end) <= size(poster,1))
        poster(Yindices,Xindices,:) = RGB{pos_ind};
    end
end
figure; imshow(poster);
imwrite(poster,'\\phkinnerets\lab\LabMeetings\niv\data\ActA\poster images\poster.png');
for i = 1:6
    imwrite(RGB{i},fullfile('\\phkinnerets\lab\LabMeetings\niv\data\ActA\poster images',sprintf('marked_%d.png',i)));
end
%% control
DIR1 = 'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample1';
DIR2 = 'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample2\';
stack1 = load_tiff_dir(DIR1,scale,'*T2_C0.tiff');
stack2 = load_tiff_dir(DIR2,scale,'*T2_C0.tiff');

%%
M = 2;
stack = stack2;
Rads = [control.DATA(M).drops.radius] * control.DATA(M).drops(1).micronsPerPixel;
% dir1:
% Ind = find(Rads < 55.4173 & Rads > 55.4171)
% Ind = find(Rads < 21.5060 & Rads > 21.5058)
% Ind = find(Rads < 15.2521 & Rads > 15.2519)
% Ind = find(Rads < 47.95 & Rads > 47.94)
% dir2:
% Ind = find(Rads < 44.16 & Rads > 44.15)
Ind = find(Rads < 24.9382 & Rads > 24.938)

[i,j] = ind2sub(size(Rads),Ind)
drop = control.DATA(M).drops(j)
xmin = drop.location(2)/relScale - 60/micronsPerPixel
ymin = drop.location(1)/relScale - 60/micronsPerPixel
for k = 1: numel(stack)
    figure;
    I = imadjust(imcrop(stack(k).planes{i},[xmin,ymin,60*2/micronsPerPixel,60*2/micronsPerPixel]));
    imshow(I);
end
%%
k=47;
j=70;
i=18;
drop = control.DATA(1).drops(j);
[ filename{1}, image{1} ] = load_tiff_file_num_plane(DIR1,scale, k, i,'*T2_C0.tiff');
RGB{1} = miniImage(image{1} ,drop,micronsPerPixel,relScale);

k=26;
j=36;
i=7;
drop = control.DATA(1).drops(j);
[ filename{2}, image{2} ] = load_tiff_file_num_plane(DIR1,scale, k, i,'*T2_C0.tiff');
RGB{2} = miniImage(image{2},drop,micronsPerPixel,relScale);

k=24;
j=33;
i=6;
drop = control.DATA(1).drops(j);
[ filename{3}, image{3} ] = load_tiff_file_num_plane(DIR1,scale, k, i,'*T2_C0.tiff');
RGB{3} = miniImage(image{3},drop,micronsPerPixel,relScale);

k=23;
j=32;
i=14;
drop = control.DATA(1).drops(j);
[ filename{4}, image{4} ] = load_tiff_file_num_plane(DIR1,scale, k, i,'*T2_C0.tiff');
RGB{4} = miniImage(image{4},drop,micronsPerPixel,relScale);

k=7;
j=17;
i=14;
drop = control.DATA(2).drops(j);
[ filename{5}, image{5} ] = load_tiff_file_num_plane(DIR2,scale, k, i,'*T2_C0.tiff');
RGB{5} = miniImage(image{5},drop,micronsPerPixel,relScale);

k=18;
j=30;
i=8;
drop = control.DATA(2).drops(j);
[ filename{6}, image{6} ] = load_tiff_file_num_plane(DIR2,scale, k, i,'*T2_C0.tiff');
RGB{6} = miniImage(image{6},drop,micronsPerPixel,relScale);

L = ceil(60*2/micronsPerPixel);
poster = zeros([L*2 + 1,L*3 + 1,3]);
for pos_ind = 1:6
    [pos_indx,pos_indy] = ind2sub([3,2],pos_ind);
    Xindices = (1:size(RGB{pos_ind},2)) + (pos_indx - 1)*L;
    Yindices = (1:size(RGB{pos_ind},1)) + (pos_indy - 1)*L;
    if(Xindices(end) <= size(poster,2) && Yindices(end) <= size(poster,1))
        poster(Yindices,Xindices,:) = RGB{pos_ind};
    end
end
figure; imshow(poster);
% imwrite(poster,'\\phkinnerets\lab\LabMeetings\niv\data\control\poster images\poster.png');
% for i = 1:6
%     imwrite(image{i},fullfile('\\phkinnerets\lab\LabMeetings\niv\data\control\poster images',sprintf('orig_%d.png',i)));
%     imwrite(RGB{i},fullfile('\\phkinnerets\lab\LabMeetings\niv\data\control\poster images',sprintf('marked_%d.png',i)));
% end