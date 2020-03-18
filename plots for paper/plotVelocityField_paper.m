function Fig = plotVelocityField_paper(Capture_folder, VDIR)
    for i=1:numel(Capture_folder);
        interrogationarea{i} = importdata([Capture_folder{i},'Analysis parameters\interrogationarea.m'],'-mat');
        
        utable_AVG_EX3{i} = importdata(fullfile(VDIR{i},'utable_AVG_EX3.mat'));
        vtable_AVG_EX3{i} = importdata(fullfile(VDIR{i},'vtable_AVG_EX3.mat'));
        xtable{i} = importdata(fullfile(VDIR{i},'xtable.mat'));
        ytable{i} = importdata(fullfile(VDIR{i},'ytable.mat'));
        calibration{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\calibration.m'),'-mat');
        Time_intervale{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\Time_intervale.m'),'-mat');
        
        dropR{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\DROP_radius.m'),'-mat'); % already calibrated
        X0drop{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\X0drop.m'),'-mat');
        Y0drop{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\Y0drop.m'),'-mat');
        chunkR{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\CHUNK_radius.m'),'-mat'); % already calibrated
        X0{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\X0.m'),'-mat');
        Y0{i} = importdata(fullfile(Capture_folder{i},'Analysis parameters\Y0.m'),'-mat');

        X0drop_calibrated{i} = X0drop{i}*calibration{i};
        Y0drop_calibrated{i} = Y0drop{i}*calibration{i};
        X0_calibrated{i} = X0{i}*calibration{i};
        Y0_calibrated{i} = Y0{i}*calibration{i};

        xtable_EX{i}=xtable{i}+interrogationarea{i}/2;
        ytable_EX{i}=ytable{i}+interrogationarea{i}/2;
        X{i} = xtable_EX{i}*calibration{i};
        Y{i} = ytable_EX{i}*calibration{i};
        U{i} = utable_AVG_EX3{i}*calibration{i}/Time_intervale{i}*60;
        V{i} = vtable_AVG_EX3{i}*calibration{i}/Time_intervale{i}*60;
        Xdilute{i} = X{i}(1:2:end,1:2:end);
        Ydilute{i} = Y{i}(1:2:end,1:2:end);
        Udilute{i} = U{i}(1:2:end,1:2:end);
        Vdilute{i} = V{i}(1:2:end,1:2:end);
        I{i} = sqrt(Vdilute{i}.^2 + Udilute{i}.^2);
    end
    %Vmax = max(max([I{:}]));
    Vmax = 20;
    
    for i=1:numel(Capture_folder);
        Fig(i) = figure('Position',[100,100,300,300]);
        Fig(i).PaperPositionMode = 'auto';
        colormap jet;
        quiverC2D(Xdilute{i},Ydilute{i},Udilute{i},Vdilute{i},5000,Vmax,0.2);
        % quiverc(Xdilute,Ydilute,Udilute,Vdilute);
        viscircles([X0drop_calibrated{i},Y0drop_calibrated{i}],dropR{i});
        viscircles([X0_calibrated{i},Y0_calibrated{i}],chunkR{i});
        axis equal
        axis off
        xlim([0,512]*calibration{i});
        ylim([0,512]*calibration{i});
        SBar(i) = scalebar('XLen',20,'YLen',1, 'XUnit', '{\mu}m', 'Border', 'LN',...
            'FontSize', 8, 'Color', 'k', 'LineWidth', 1);
        CBar(i) = colorbar('south');
        CPos = CBar(i).Position;
        CPos(4) = CPos(4)/2.5;
        CBar(i).Position = CPos;
        CBar(i).AxisLocation = 'out';
        caxis([0,Vmax]);
    end
end