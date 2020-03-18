function do_correlations_z_t(DIR, Rrange, micronsPerPixel)
% BIGDROPS_WRAPPER a wrapper function for bigdrops_auto_analysis.
% Reads parametr file and filters file and executes BIGDROPS_AUTO_ANALYSIS
% on the filtered tiffs
% Input:
%   param_file - parameters file to be read by READ_PAR.
%   M - line number in filters file, or string to be used as suffix.
% see also emulsion_auto_analysis, read_par
DIRt = fullfile(DIR,'time-lapse');
DIRz = fullfile(DIR,'z-stack');
if ~exist(DIR,'dir')
    error('DIR %s does not exist', DIR);
end
if ~exist(DIRt,'dir')
    error('DIRt %s does not exist', DIRt);
end
if ~exist(DIRz,'dir')
    error('DIRz %s does not exist', DIRz);
end

if nargin < 3 || isempty(micronsPerPixel)
    micronsPerPixel = -1;
end

if nargin < 2 || isempty(Rrange)
    if exist(fullfile(DIR,'Rrange.txt'),'file')
        Rrange = dlmread(fullfile(DIR,'Rrange.txt'));
    else
        Rrange = -1;
    end
end
Rrange = sort(Rrange);

Dz = dir(fullfile(DIRz,'*.tiff'));
Dt = dir(fullfile(DIRt,'*.tiff'));

if numel(Dz) ~= 1 || numel(Dt) ~=1
    error('numel Dz: %d \nnumel Dt: %d', numel(Dz),numel(Dt));
end
if exist(fullfile(DIR,'z_drop.mat'),'file')
    load(fullfile(DIR,'z_drop.mat'));
else
    z_file = fullfile(DIRz,Dz.name);
    z_stack = load_tiff_file(z_file,1);
    z_stack = cellfun(@(x) double(x)/double(max(max(x))),z_stack,'UniformOutput',false);
    z_drop = extract_drops_oop(z_stack,DIRz,Rrange,micronsPerPixel,'nodetect','nofindcenter');
    z_drop.centerPlane = ceil(z_drop.numOfPlanes/2);
    save(fullfile(DIR,'z_drop'),'z_drop','-v7.3')
end

if exist(fullfile(DIR,'t_drops.mat'),'file')
    load(fullfile(DIR,'t_drops.mat'));
else
    t_file = fullfile(DIRt,Dt.name);
    t_stack = load_tiff_file(t_file,1);
    t_stack = cellfun(@(x) double(x)/double(max(max(x))),t_stack,'UniformOutput',false);
    t_drops = [];
    for d = 1:numel(t_stack)
        tdrop = extract_drops_oop(t_stack(d),DIRt,Rrange,micronsPerPixel,'nodetect','nofindcenter');
        if isempty(tdrop)
            tdrop = drop;
        else
            tdrop.centerPlane = 1;
        end
        t_drops = [t_drops, tdrop];
    end
    save(fullfile(DIR,'t_drops'),'t_drops','-v7.3')
end
r1 = z_drop.getRadius('pixels');
dx1 = round(r1*0.8/sqrt(2));
%SE = strel('ball',50,10,0);
SE = strel('ball',10,2,2);

for plane = 1:z_drop.numOfPlanes;
    Roi1{plane} = getRoi(z_drop,plane,dx1);
%     R1Fm{plane} = imtophat(Roi1{plane},SE);
     R1Fm{plane} = imbothat(Roi1{plane},SE);
    R1Fm{plane} = R1Fm{plane} - mean(R1Fm{plane}(:));
end

for t=1:(numel(t_drops))
    if isempty(t_drops(t).images)
        corr_vec(:,t) = [nan; nan];
        p(t) = nan;
    else
        Roi2 = getRoi(t_drops(t),1,dx1);
%         R2Fm = imtophat(Roi2,SE);
        R2Fm = imbothat(Roi2,SE);
        R2Fm = R2Fm - mean(R2Fm(:));
        
        for i = 1:z_drop.numOfPlanes
            crr{i} = xcorr2(R1Fm{i},R2Fm);
        end
        M = cellfun(@(x) max(x(:)),crr);
        [~,ind] = max(M);
        [~,snd] = max(crr{ind}(:));
        [ij,ji] = ind2sub(size(crr{ind}),snd);
        offset = [ij,ji] - size(Roi2)/2 - size(Roi1{ind})/2;
        corr_vec(:,t) = offset';
        p(t) = ind;
    end
end
corr_vec = corr_vec*t_drops(1).micronsPerPixel;
save(fullfile(DIR,'corr_vec'),'corr_vec','p','-v7.3')
end

