function Fig = plot_symbreaking(DIRS,scatterDots,append)
% PLOT_SYMBREAKING
% function Fig = plot_symbreaking(DIRS,append)
% plot average symmbreaking as a function of drop diameter,
%      and symmbreaking probabality as a function of drop diameter.
% figures saved to first directory in DIRS.
%
% input
% DIRS      cell array of data directories, columns will be loaded together and
% plotted in a different color.
%
% append    optional. string to append to figure name and filename.
%
% output
% Fig       array of 2 figures handle.

% DIRS = varargin;
S = size(DIRS);
%CustomColorOdr = [     0.4,       0.4,       0.4; ...
%                         0,    0.4470,    0.7410; ...
%                    0.8500,    0.3250,    0.0980; ...
%                    0.4940,    0.1840,    0.5560; ...
%                    0.4660,    0.6740,    0.1880; ...
%                    0.3010,    0.7450,    0.9330; ...
%                    0.6350,    0.0780,    0.1840];
% f = figure; CustomColorOdr = get(gca,'ColorOrder'); close(f);
% if exist('scatterDots','var') && scatterDots
%     CustomColorOdrHSV = rgb2hsv(CustomColorOdr);
%     CustomColorOdrHSV(:,2) = CustomColorOdrHSV(:,2)*0.6;
%     CustomColorOdrHSV(:,3) = min(1,CustomColorOdrHSV(:,3)*1.4);
%     CustomColorOdrWahed = hsv2rgb(CustomColorOdrHSV);
% %    CustomColorOdrHSV(CustomColorOdrHSV(:,2) == 0,3) = min(1, CustomColorOdrHSV(CustomColorOdrHSV(:,2) == 0,3) * 1.6);
%     %CustomColorOdrHSV(:,3) = min(1, CustomColorOdrHSV(:,3)*1.4);
% %     CustomColorOdrWahed = min(1, CustomColorOdr + 0.4);
%     CustomColorOdr = kron(CustomColorOdr,[1;1]);
%     CustomColorOdr(1:2:end-1,:) = CustomColorOdrWahed;
% end

                
fields={'blobDistanceMinusPlus','dropRadius','dropEffectiveRadius'};
dropVectors = loadDropsVectors(DIRS,fields);

% limits on drop diameter
Lmin = 30;
Lmax = 110;

% figure size 500x350
Fig(1) = figure('Position',[100 100 500 350]);
Fig(1).PaperPositionMode = 'auto';
Fig(1).Name = 'average_symbreaking - '; % figure name prefix
%set(gca,'ColorOrder',CustomColorOdr);  
hold on

Fig(2) = figure('Position',[100 100 500 350]);
Fig(2).PaperPositionMode = 'auto';
Fig(2).Name = 'symbreaking_probability - '; % figure name prefix
%set(gca,'ColorOrder',CustomColorOdr);  
hold on

% for j = 1:S
%     DIR = DIRS{j};
%     % read data
%     blobDistanceMinusPlus{j} = dlmread(fullfile(DIR,'blobDistanceMinusPlus'));
%     dropRadius{j} = dlmread(fullfile(DIR,'dropRadius'));
%     dropEffectiveRadius{j} = dlmread(fullfile(DIR,'dropEffectiveRadius'));
%     FID = fopen(fullfile(DIR,'description'),'r');
%     description{j} = fscanf(FID,'%s');
%     fclose(FID);
% end
thresh = 0.6;
for i = 1:S(1)
    % calculate symmetry breaking
%     symbreaking{j} = blobDistanceMinusPlus{j}(1,:)./dropEffectiveRadius{j};
    blobDistanceMinusPlus =[dropVectors(i,:).blobDistanceMinusPlus];
    symbreaking{i} = blobDistanceMinusPlus(1,:)./[dropVectors(i,:).dropEffectiveRadius];

    symbreaking{i}(symbreaking{i} > 1) = 1;

    % sort according to drop radius
    [sortedRadius{i},I{i}] = sort([dropVectors(i,:).dropRadius]);
    sortedsymbreaking{i} = symbreaking{i}(I{i});
    symbreakingThresh{i} = sortedsymbreaking{i};
    symbreakingThresh{i}(sortedsymbreaking{i} >= thresh) = 1;
    symbreakingThresh{i}(sortedsymbreaking{i} < thresh) = 0;

    % calculate gaussian and average
    sigma = 5;

    di = repmat(sortedsymbreaking{i},length(symbreaking{i}),1);
    diThreshed = repmat(symbreakingThresh{i},length(symbreakingThresh{i}),1);

    [ri,r0] = meshgrid(sortedRadius{i},sortedRadius{i});
    r = ri - r0;
    expo = exp(-(r.^2)/(2*sigma));
    norm = sum(expo);
    avg = sum(di'.*expo)./norm;
    avgThreshed = sum(diThreshed'.*expo)./norm;

    % plot average symmetry breaking
    figure(Fig(1));
    symbreaking_plot(i) = plot(sortedRadius{i}*2,avg,'linewidth',2);
    if exist('scatterDots','var') && scatterDots
        currentColorIndex = get(gca, 'ColorOrderIndex');   
        set(gca, 'ColorOrderIndex', currentColorIndex - 1);
        scatter(sortedRadius{i}*2, sortedsymbreaking{i},20,'o','filled');
    end
    symbreaking_plot(i).DisplayName = sprintf('%s, N=%d',dropVectors(i,1).description, length(sortedRadius{i})); % string to dispaly in legend
    legend('off');
    % add description to figure name
    Fig(1).Name = [Fig(1).Name, dropVectors(i,1).description];
    if i<S(1)
        Fig(1).Name = [Fig(1).Name, ', '];
    elseif exist('append','var')
        Fig(1).Name = [Fig(1).Name, append];
    end
    
    % plot symmetry breaking probability
    figure(Fig(2)); 
    symbreaking_thresh_plot(i) = plot(sortedRadius{i}*2,avgThreshed,'linewidth',2);
    if exist('scatterDots','var') && scatterDots
        currentColorIndex = get(gca, 'ColorOrderIndex');   
        set(gca, 'ColorOrderIndex', currentColorIndex - 1);
        scatter(sortedRadius{i}*2, sortedsymbreaking{i},20,'o','filled');
    end
    symbreaking_thresh_plot(i).DisplayName = sprintf('%s, N=%d',dropVectors(i,1).description, length(sortedRadius{i})); % string to dispaly in legend
    legend('off');
    % add description to figure name
    Fig(2).Name = [Fig(2).Name, dropVectors(i,1).description];
    if i<S(1)
        Fig(2).Name = [Fig(2).Name, ', '];
    elseif exist('append','var')
        Fig(2).Name = [Fig(2).Name, append];
    end

end
figure(Fig(1));
ax = gca;
ax.FontSize = 16;
xlabel('Drop Diameter [{\mu}m]');
ylabel('Normalized displacement');
xlim([Lmin,Lmax]);
ylim([0,1]);
ax.YTick = [0,1];
ax.YTickLabel = {'Centered', 'Polar'};

hold off
h = legend(symbreaking_plot,'location','best');
%h.FontSize = 10;

figure(Fig(2));
ax = gca;
ax.FontSize = 16;
xlabel('Drop Diameter [{\mu}m]');
ylabel('Symmetry breaking Probability');
xlim([Lmin,Lmax]);
ylim([0,1]);
ax.YTick =[0,0.5,1];
hold off
h = legend(symbreaking_thresh_plot,'location','best');
%h.FontSize = 10;

% save figure
print(Fig(1),fullfile(DIRS{1},[Fig(1).Name,'.eps']),'-depsc');
print(Fig(2),fullfile(DIRS{1},[Fig(2).Name,'.eps']),'-depsc');

end