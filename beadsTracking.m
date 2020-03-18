function [tracksForMsdanalyzer, magnetPos, calibration, images, roiPos] = beadsTracking(filename, frames)
    %MOVIEANALYSIS
    %Inputs:
    %	videoFilename - name of avi file or directory containing avi file
    %	calibration - microns per pixel
    %	removeFrames - list of frames to remove
    %Outputs:
    %tracksForMsdanalyzer - particle tracks formatted for MSDAnalyzer
%-------------------------------------------------------------------------%
    
    %     filename = 'W:\phkinnerets\storage\analysis\Niv\magnetic beads\magnetic beads in capillary\beads in water\2019_03_03\Capture 3';

    tiffFilename = [filename,'.tiff'];
    logFilename = [filename,'.log'];
    [calibration, ~, timeSep] = readCalibration(logFilename);
    
    images = load_tiff_file_array(tiffFilename, 1, 'uint16');
    framerate = 1/timeSep;
    S = size(images);
    FigROI = figure; imshow(images(:,:,frames(10)));
    title('Select ROI...');
    hRoi = imrect;
    roiPos = wait(hRoi);
    title('Select magnet position...');
    hMagnet = impoint;
    magnetPos = wait(hMagnet);
    title('ROI');
    magnetPos = magnetPos * calibration;
    iMin = max(1, round(roiPos(2)));
    iMax = min(S(1), round(roiPos(2) + roiPos(4)));
    jMin = max(1, round(roiPos(1)));
    jMax = min(S(2), round(roiPos(1) + roiPos(3)));
    imagesCroped = images(iMin:iMax,jMin:jMax,:);

%     t = round((1:S(3))/framerate,5);
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
        RP = regionprops(L,NormBP,'WeightedCentroid', 'Area','MajorAxisLength');
        pk = [vertcat(RP.WeightedCentroid), vertcat(RP.Area), vertcat(RP.MajorAxisLength)];
        pk = pk + repmat([jMin - 1, iMin - 1, 0, 0],size(pk,1),1);
%         pk = pkfnd(frameBpass,2000,10);
%         cnt = cntrd(double(frameBpass),pk,11,1);
        pkAll = [pkAll; pk, ones(size(pk,1),1) * frame];
%         cntAll = [cntAll; cnt, ones(size(cnt,1),1) * frame];
    end
%     t = round(((1:size(imagesCroped,3)))/framerate,5);
    param.mem = 0;
    param.dim = 3;
    param.good = 5;
    param.quiet = 0;
    trDiffAll = [];
%     tracks = track(cntAll(:,[1,2,5]),5,param);
    tracksFull = track(pkAll,13,param);
%     tracks = tracksFull(:,[1,2,4,5]);
%     clear tracksForMsdanalyzer;
    for trackNum = 1:max(tracksFull(:,6))
        tr = tracksFull(tracksFull(:,6) == trackNum,:);
        tracksForMsdanalyzer{trackNum} = [round(tr(:,5)/framerate,5),tr(:,1:2)*calibration, tr(:,3)*calibration^2,  tr(:,4)*calibration];
%         tracksForMsdanalyzer{trackNum} = [round(tr(:,3)/framerate,5),tr(:,1:2)];
    end
end

