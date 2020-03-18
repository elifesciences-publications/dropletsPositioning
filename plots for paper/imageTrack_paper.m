function Fig = imageTrack_paper(CCData, imageFilename, lastMagnetFrame)
    t = Tiff(imageFilename);
    tiffInfo = imfinfo(imageFilename);
    t.setDirectory(lastMagnetFrame);
    im = t.read();
    t.close();
    Fig = figure;
%     Fig.Renderer = 'painters';
    imshow(im);
%     imagesc(im);
%     colormap('gray');
%     axis equal
%     axis off
    x = CCData.Xaggregate - CCData.Xdroplet + CCData.Xdroplet(lastMagnetFrame);
    y = CCData.Yaggregate - CCData.Ydroplet + CCData.Ydroplet(lastMagnetFrame);
    hold on;
    plot(x(1:lastMagnetFrame),y(1:lastMagnetFrame),'LineWidth',2,'Color', [1,0,0]);
    plot(x(lastMagnetFrame:end),y(lastMagnetFrame:end),'LineWidth',1,'Color', [0,0,1]);
    scalebar('XLen',20,'YLen',1, 'XUnit', '{\mu}m', 'Border', 'LN',...
        'FontSize', 8, 'Color', 'w', 'LineWidth', 2, 'Calibration', CCData.calibration,...
        'Position',[300,350]);
    ylim([141,385]);
    xlim([1,430]);
end

