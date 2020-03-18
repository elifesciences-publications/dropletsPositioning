filename = 'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\beads in water\2019_03_03\Capture 10';
frames = 25:308;

    tiffFilename = [filename,'.tiff'];
    logFilename = [filename,'.log'];
    [calibration, ~, timeSep] = readCalibration(logFilename);
    
    images = load_tiff_file_array(tiffFilename, 1, 'uint16');
    framerate = 1/timeSep;
    S = size(images);
    figure; imagesc(images(:,:,frames(10)));
    title('Select ROI...');
    hRoi = imrect;
    roiPos = wait(hRoi);
    title('ROI');
    
    iMin = max(1, round(roiPos(2)));
    iMax = min(S(1), round(roiPos(2) + roiPos(4)));
    jMin = max(1, round(roiPos(1)));
    jMax = min(S(2), round(roiPos(1) + roiPos(3)));

    imagesCroped = images(iMin:iMax,jMin:jMax,:);
    if exist('frames','var') && ~isempty(frames)
%         t = t(frames);
        imagesCroped = imagesCroped(:,:,frames);
    end
    pkAll=[];
    cntAll=[];
    for frame = 1:size(imagesCroped,3)
        frameBpass = bpass(max(max(imagesCroped(:,:,frame))) - imagesCroped(:,:,frame),0.7,5, 800);
        NormBP = frameBpass./max(frameBpass(:));
        BW = im2bw(NormBP,0.1);
        L = bwlabel(BW, 4);
        RP = regionprops(L,NormBP,'WeightedCentroid', 'Area');
        pk = [vertcat(RP.WeightedCentroid), vertcat(RP.Area)];
        pk = pk + repmat([jMin - 1, iMin - 1, 0],size(pk,1),1);

%         pk = pkfnd(frameBpass,4000,10);
%         cnt = cntrd(double(frameBpass),pk,7,1);
        pkAll = [pkAll; pk, ones(size(pk,1),1) * frame];
%         cntAll = [cntAll; cnt, ones(size(cnt,1),1) * frame];
    end
%     t = round(((1:size(imagesCroped,3)))/framerate,5);
    param.mem = 0;
    param.dim = 2;
    param.good = 5;
    param.quiet = 0;
    trDiffAll = [];
%     tracks = track(cntAll(:,[1,2,5]),5,param);
    tracksFull = track(pkAll,6,param);
%     tracks = tracksFull(:,[1,2,4,5]);
%     clear tracksForMsdanalyzer;
    for trackNum = 1:max(tracksFull(:,5))
        tr = tracksFull(tracksFull(:,5) == trackNum,:);
        tracksAll{trackNum} = [round(tr(:,4)/framerate,5),tr(:,1:2)*calibration, tr(:,3)*calibration^2];
%         tracksForMsdanalyzer{trackNum} = [round(tr(:,3)/framerate,5),tr(:,1:2)];
    end

tracksForMsdAnalyzer = cellfun(@(x) x(:,1:3),tracksAll,'UniformOutput',false);
ma = msdanalyzer(2, 'µm', 'sec');
ma = ma.addAll(tracksForMsdAnalyzer);
S = size(images(:,:,1));
figure;
im = imagesc(min(images(:,:,frames),[],3), 'XData', [0,511*calibration], 'YData', [0,511*calibration]);
hold on; ma.plotTracks;

ma = ma.computeMSD;
ma = ma.fitMSD;
fit = ma.fitMeanMSD;

figure;
ma.plotMeanMSD(gca, true);
ma.labelPlotMSD(gca);
hold on;
pl = plot(fit);
display(sprintf('D = %.2g',fit.p1/4));

mu = 8.9e-10; % kg/s/um
KB = 1.38064852e-11;
T = 273 + 25;
beadR = 0.5; %um
D = KB*T/(6*pi*beadR*mu);
t = pl.XData;
y = 4*D*t;
plot(t,y);