% control1.filename = {'Z:\analysis\Niv\tracking\2016_12_11\80percent_extract+XB\mix2 sample4 time17_52\capture 1\analysis_data_oop_tracking.mat'};
% control1.description = 'Control';
% control1.basename = 'analysis_data_oop_tracking';
% control1.times = 0:2:598;
% 
% DATA = load(control1.filename{1});
% if isfield(DATA,'DATA')
%     DATA = DATA.DATA;
% end
% % [DATA.drops.images] = deal([]);
% control1.DATA.drops = DATA.drops;
control1.filename = {'Z:\analysis\Niv\tracking\2016_12_11\80percent_extract+XB\mix2 sample4 time17_52\capture 1\analysis_data_oop_tracking_correlation.mat'};
control1.description = 'Control';
control1.basename = 'analysis_data_oop_tracking_correlation';
control1.times = 0:2:598;
control1.DATA = load(control1.filename{1});
[control1.DATA.drops.images] = deal([]);
control1.BV = blob_vectors(control1.DATA.drops);
Fig(1) = scatter_tracking_oop(control1');
Fig(10) = scatter_tracking_xy(control1');

control2.filename = {'Z:\analysis\Niv\tracking\2016_12_11\80percent_extract+XB\mix2 sample2 time17_23\capture 1\analysis_data_oop_tracking_correlation.mat'};
control2.description = 'Control';
control2.basename = 'analysis_data_oop_tracking_correlation';
control2.times = 0:2:598;
control2.DATA = load(control2.filename{1});
[control2.DATA.drops.images] = deal([]);
control2.BV = blob_vectors(control2.DATA.drops);
Fig(2) = scatter_tracking_oop(control2');
Fig(11) = scatter_tracking_xy(control2');

control3.filename = {'Z:\analysis\Niv\tracking\2017_01_31\control 80percent_extract + LA-GFP\mix2 sample1\capture1\analysis_data_oop_tracking_correlation.mat'};
control3.description = 'Control';
control3.basename = 'analysis_data_oop_tracking_correlation';
control3.times = 0:2:366;
control3.DATA = load(control3.filename{1});
[control3.DATA.drops.images] = deal([]);
control3.BV = blob_vectors(control3.DATA.drops);
Fig(3) = scatter_tracking_oop(control3');
Fig(12) = scatter_tracking_xy(control3');

control4.filename = {'Z:\analysis\Niv\tracking\2017_01_31\control 80percent_extract + LA-GFP\mix2 sample1\capture2\analysis_data_oop_tracking_correlation.mat'};
control4.description = 'Control';
control4.basename = 'analysis_data_oop_tracking_correlation';
control4.times = 0:2:598;
control4.DATA = load(control4.filename{1});
[control4.DATA.drops.images] = deal([]);
control4.BV = blob_vectors(control4.DATA.drops);
Fig(4) = scatter_tracking_oop(control4');

%good up to ~140:
control5.filename = {'Z:\analysis\Niv\tracking\2017_01_31\control 80percent_extract + LA-GFP\mix2 sample1\capture3 - continue2\analysis_data_oop_tracking_correlation.mat'};
control5.description = 'Control';
control5.basename = 'analysis_data_oop_tracking_correlation';
control5.times = 0:2:598;
control5.DATA = load(control5.filename{1});
[control5.DATA.drops.centerPlane] = deal(0);
[control5.DATA.drops.images] = deal([]);
control5.BV = blob_vectors(control5.DATA.drops);
Fig(5) = scatter_tracking_oop(control5');

control45.filename = [control4.filename;control5.filename];
control45.description = 'Control';
control45.times = (0:600 )* 2;
control45.DATA = control4.DATA;
control45.DATA.drops = [control45.DATA.drops,control5.DATA.drops(1:140)];
control45.BV = [control4.BV,control5.BV(1:140)];
Fig(8) = scatter_tracking_oop(control45');
Fig(13) = scatter_tracking_xy(control45');

control6.filename = {'Z:\analysis\Niv\tracking\2017_01_31\control 80percent_extract + LA-GFP\mix2 sample2\capture2\analysis_data_oop_tracking_correlation.mat'};
control6.description = 'Control';
control6.basename = 'analysis_data_oop_tracking_correlation';
control6.times = 0:2:594;
control6.DATA = load(control6.filename{1});
[control6.DATA.drops.images] = deal([]);
control6.BV = blob_vectors(control6.DATA.drops);
Fig(6) = scatter_tracking_oop(control6');
Fig(9) = scatter_tracking_xy(control6);

control7.filename = {'Z:\analysis\Niv\tracking\2017_01_31\control 80percent_extract + LA-GFP\mix2 sample2\capture3 - continue2\analysis_data_tracking_correlation.mat'};
control7.description = 'Control';
control7.basename = 'analysis_data_tracking_correlation';
control7.DATA = load(control7.filename{1});
control7.times = 0:2:(length(control7.DATA.drops)*2 - 2) ;
[control7.DATA.drops.images] = deal([]);
control7.BV = blob_vectors(control7.DATA.drops);
Fig(7) = scatter_tracking_oop(control7');
%%
load('Z:\analysis\Niv\tracking\2017_03_06\80%_extract\mix1 sample1\capture 7-8\z_drop.mat');
load('Z:\analysis\Niv\tracking\2017_03_06\80%_extract\mix1 sample1\capture 7-8\t_drops.mat');
%%
TAG='plot_large_font_tracking_cut_';
for i = 1:numel(Fig)
        title(Fig(i).Children(1),'');
        print(Fig(i),'-depsc',['..\plots\emulsions_plots\',TAG,num2str(i),'.eps']);
%         export_fig(['../',filename{i},'_exfig'],'-png','-m4',Fig(i));
end

%%
BVEC{1} = [control1.BV.blobVec];
BVEC{2} = [control2.BV.blobVec];
BVEC{3} = [control3.BV.blobVec];
BVEC{4} = [control45.BV.blobVec];
BVEC{5} = [control6.BV.blobVec];
times{1} = control1.times(find(~cellfun('isempty',{control1.BV.dropR})));
times{2} = control2.times(find(~cellfun('isempty',{control2.BV.dropR})));
times{3} = control3.times(find(~cellfun('isempty',{control3.BV.dropR})));
times{4} = control45.times(find(~cellfun('isempty',{control45.BV.dropR})));
times{5} = control6.times(find(~cellfun('isempty',{control6.BV.dropR})));

for i=1:5
    figure;
    hold on
    plot(times{i},rms_vec(BVEC{i}(1,:)),'.')
    plot(times{i},rms_vec(BVEC{i}(2,:)),'.')
    plot(times{i},rms_vec(sqrt(BVEC{i}(1,:).^2 + BVEC{i}(2,:).^2)),'.')
    legend({'RMS(x)','RMS(y)','RMS(displacement)'},'fontsize',14);
    ylabel('microns','fontsize',14);
    xlabel('seconds','fontsize',14);
end
% figure;
% hold on
% for i=1:5
%     plot(times{i},rms_vec(BVEC{i}(2,:)),'.')
% end
% figure;
% hold on
% for i=1:5
%     plot(times{i},rms_vec(sqrt(BVEC{i}(1,:).^2 + BVEC{i}(2,:).^2)),'.')
% end

%%
% drop not detected
% control6.filename = {'Z:\analysis\Niv\tracking\2017_01_31\control 80percent_extract + LA-GFP\mix2 sample2\capture5\analysis_data_oop_tracking_correlation.mat'};
% control6.description = 'Control';
% control6.basename = 'analysis_data_oop_tracking_correlation';
% control6.times = 0:2:598;
% control6.DATA = load(control6.filename{1});
% [control6.DATA.drops.images] = deal([]);
% control6.BV = blob_vectors(control6.DATA.drops);
% scatter_tracking_oop(control6');


