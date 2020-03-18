% control
N=4;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[control(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_14\control extract+XB\sample 1'});
[control(1:N).description] = deal('Control');
[control(1:N).time] = deal(times{:});
[control(1:N).line] = deal(lines{:});
[control(1:N).basename] = deal('analysis_data_auto_');
[control(2:3).basename] = deal('analysis_data_');
control = load_plot_dirs( control );

scatter_and_histograms(control');

N=7;
times = num2cell([5:5:30,45]);
lines = num2cell(1:N);
[control_s(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_14\control extract+XB\sample 2'});
[control_s(1:N).description] = deal('Control');
[control_s(1:N).time] = deal(times{:});
[control_s(1:N).line] = deal(lines{:});
[control_s(1:N).basename] = deal('analysis_data_auto_');
control_s = load_plot_dirs( control_s );

scatter_and_histograms(control_s');
%%
% control with LA-GFP
N=4;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[control_LA(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample1'});
[control_LA(:).description] = deal('Control with LA-GFP');
[control_LA(:).time] = deal(times{:});
[control_LA(:).line] = deal(lines{:});
[control_LA(1:N).basename] = deal('analysis_data_');
control_LA = load_plot_dirs( control_LA );

scatter_and_histograms(control_LA');

% control with LA-GFP 2
N=4;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[control_LA2(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample2'});
[control_LA2(:).description] = deal('Control with LA-GFP');
[control_LA2(:).time] = deal(times{:});
[control_LA2(:).line] = deal(lines{:});
[control_LA2(1:N).basename] = deal('analysis_data_auto_');
control_LA2(3).basename = 'analysis_data_';
control_LA2 = load_plot_dirs( control_LA2 );

scatter_and_histograms(control_LA2');
%%
% CP + CARMIL
N=4;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[cp_carmil(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_04\CP+carmil'});
[cp_carmil(1:N).description] = deal('CP + CARMIL');
[cp_carmil(1:N).time] = deal(times{:});
[cp_carmil(1:N).line] = deal(lines{:});
[cp_carmil(1:N).basename] = deal('analysis_data_auto_');
cp_carmil(3).basename = 'analysis_data_';

cp_carmil = load_plot_dirs( cp_carmil );

scatter_and_histograms(cp_carmil');
%%
% Abp1 + Srv2, 2muM each
N=4;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[Srv_Abp_2muM_1(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_07\Srv2_2muM+Abp1_2muM'});
[Srv_Abp_2muM_1(1:N).description] = deal('2muM Abp1 + Srv2 1');
[Srv_Abp_2muM_1(1:N).time] = deal(times{:});
[Srv_Abp_2muM_1(1:N).line] = deal(lines{:});
[Srv_Abp_2muM_1(1:N).basename] = deal('analysis_data_auto_');
Srv_Abp_2muM_1(3).basename = 'analysis_data_';
Srv_Abp_2muM_1 = load_plot_dirs( Srv_Abp_2muM_1 );

scatter_and_histograms(Srv_Abp_2muM_1');

N=3;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[Srv_Abp_2muM_2(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_12\Srv2_2muM+Abp1_2muM\mix4 sample1'});
[Srv_Abp_2muM_2(1:N).description] = deal('2muM Abp1 + Srv2 2');
[Srv_Abp_2muM_2(1:N).time] = deal(times{:});
[Srv_Abp_2muM_2(1:N).line] = deal(lines{:});
[Srv_Abp_2muM_2(1:N).basename] = deal('analysis_data_auto_');
[Srv_Abp_2muM_2(1,3).basename] =  deal('analysis_data_');

Srv_Abp_2muM_2 = load_plot_dirs( Srv_Abp_2muM_2 );

Figs(3) = scatter_and_histograms(Srv_Abp_2muM_2');
N=3;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[Srv_Abp_2muM_3(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_12\Srv2_2muM+Abp1_2muM\mix4 sample2'});
[Srv_Abp_2muM_3(1:N).description] = deal('2muM Abp1 + Srv2 3');
[Srv_Abp_2muM_3(1:N).time] = deal(times{:});
[Srv_Abp_2muM_3(1:N).line] = deal(lines{:});
[Srv_Abp_2muM_3(1:N).basename] = deal('analysis_data_auto_');
[Srv_Abp_2muM_3(1,3).basename] =  deal('analysis_data_');
Srv_Abp_2muM_3 = load_plot_dirs( Srv_Abp_2muM_3 );

scatter_and_histograms(Srv_Abp_2muM_3');

%%
% ActA + Abp1 + Srv2 
N=4;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[ActA_Srv_Abp(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_07\ActA+srv2+Abp1'});
[ActA_Srv_Abp(1:N).description] = deal('ActA + Abp1 + Srv2');
[ActA_Srv_Abp(1:N).time] = deal(times{:});
[ActA_Srv_Abp(1:N).line] = deal(lines{:});
[ActA_Srv_Abp(1:N).basename] = deal('analysis_data_auto_');
ActA_Srv_Abp(3).basename = 'analysis_data_';

ActA_Srv_Abp = load_plot_dirs( ActA_Srv_Abp );

scatter_and_histograms(ActA_Srv_Abp');
%%
% Abp1 + Srv2, 1muM each
N=3;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[Srv_Abp_1muM(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_09\Srv2_1muM+Abp1_1muM\big drops'});
[Srv_Abp_1muM(1:N).description] = deal('1muM Abp1 + Srv2');
[Srv_Abp_1muM(1:N).time] = deal(times{:});
[Srv_Abp_1muM(1:N).line] = deal(lines{:});
[Srv_Abp_1muM(1:N).basename] = deal('analysis_data_auto_');
Srv_Abp_1muM(3).basename = 'analysis_data_';
Srv_Abp_1muM = load_plot_dirs( Srv_Abp_1muM );

scatter_and_histograms(Srv_Abp_1muM');
%%
% mDia
N=3;
times = num2cell(10:15:(15*N-5));
lines = num2cell(1:N);
[mDia(1:N).dirname] = deal({'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_11\mDia\sample1'});
[mDia(1:N).description] = deal('mDia');
[mDia(1:N).time] = deal(times{:});
[mDia(1:N).line] = deal(lines{:});
[mDia(1:N).basename] = deal('analysis_data_auto_');
[mDia(2:3).basename] = deal('analysis_data_');
mDia = load_plot_dirs( mDia );

scatter_and_histograms(mDia');
%% compare
comparison(1).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP ActA'};
comparison(1).description = 'ActA';
comparison(1).time = 60;
comparison(1).line = 1;

comparison(2).dirname = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_07\ActA+srv2+Abp1'};
comparison(2).description = 'ActA + Abp1 + Srv2';
comparison(2).time = 40;
comparison(2).line = 3;

comparison(3).dirname = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_07\Srv2_2muM+Abp1_2muM'};
comparison(3).description = '2muM Abp1 + Srv2';
comparison(3).time = 40;
comparison(3).line = 3;

comparison(4).dirname = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_09\Srv2_1muM+Abp1_1muM\big drops'};
comparison(4).description = '1muM Abp1 + Srv2';
comparison(4).time = 40;
comparison(4).line = 3;

comparison(5).dirname = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_14\control extract+XB\sample 1'};
comparison(5).description = 'Control';
comparison(5).time = 40;
comparison(5).line = 3;

comparison(6).dirname = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_04\CP+carmil'};
comparison(6).description = 'CP +CARMIL';
comparison(6).time = 40;
comparison(6).line = 3;

comparison(7).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample1 time09_55',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample2 time11_35'};
comparison(7).description = 'CCA';
comparison(7).time = 45;
comparison(7).line = 4;

comparison(8).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 3.3muM_TPM3.1'};
comparison(8).description = 'TPM3.1';
comparison(8).time = 45;
comparison(8).line = 4;

comparison(9).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 3muM_TPM3.1 + ActA'};
comparison(9).description = 'TPM3.1 + ActA';
comparison(9).time = 45;
comparison(9).line = 4;

comparison(10).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_11_01\3muM_TPM3.1 30mM_KCl'};
comparison(10).description = 'TPM3.1 + KCl';
comparison(10).time = 45;
comparison(10).line = 4;

comparison(11).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 1'...
        ,'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 2'};
comparison(11).description = 'control 2';
comparison(11).time = 30;
comparison(11).line = 3;

comparison(12).dirname = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_11\mDia\sample1'};
comparison(12).description = 'mDia';
comparison(12).time = 40;
comparison(12).line = 3;

comparison(13).dirname = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample1',...
        'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample2'};
comparison(13).description = 'Control with LA-GFP';
comparison(13).time = 40;
comparison(13).line = 3;

comparison(14).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_12_13\alpha-actinin_10muM\sample1\'};
comparison(14).description = 'Alpha-Actinin 10muM';
comparison(14).time = 40;
comparison(14).line = 3;

comparison(15).dirname = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_12_13\alpha-actinin_5muM\sample1\'};
comparison(15).description = 'Alpha-Actinin 5muM';
comparison(15).time = 40;
comparison(15).line = 3;

[comparison(:).basename] = deal('analysis_data_');

comparison = load_plot_dirs( comparison );
clear Figs
Figs(1,:) = scatter_and_histograms(comparison(13)); % control with LA
Figs(end+1,:) = scatter_and_histograms(comparison([13,1])); % ActA Vs control with LA
Figs(end+1,:) = scatter_and_histograms(comparison([13,3])); % Abp1+Srv2(2muM) Vs control with LA
Figs(end+1,:) = scatter_and_histograms(comparison([13,2])); % ActA+Abp1+Srv2 Vs control with LA
% scatter_and_histograms(comparison([1,2])); % ActA Vs ActA+Abp1+Srv2
% scatter_and_histograms(comparison([3,2])); % Abp1+Srv2 (2muM) Vs ActA+Abp1+Srv2
% scatter_and_histograms(comparison([3,4])); % Abp1+Srv2 (2muM) Vs Abp1+Srv2 (1muM)
% scatter_and_histograms(comparison([4,13])); % Abp1+Srv2 (1muM) Vs control
Figs(end+1,:) = scatter_and_histograms(comparison([13,6])); % CP +CARMIL Vs control with LA
Figs(end+1,:) = scatter_and_histograms(comparison([13,7])); % CCA Vs control with LA
Figs(end+1,:) = scatter_and_histograms(comparison([13,8])); % TPM Vs control with LA
% scatter_and_histograms(comparison([9,13])); % TPM + ActA Vs control with LA
Figs(end+1,:) = scatter_and_histograms(comparison([9,1])); % TPM + ActA Vs ActA
Figs(end+1,:) = scatter_and_histograms(comparison([9,8])); % TPM + ActA Vs TPM
Figs(end+1,:) = scatter_and_histograms(comparison([10,8])); % TPM + KCl Vs TPM
% scatter_and_histograms(comparison([11,5,13])); % controls
Figs(end+1,:) = scatter_and_histograms(comparison([13,12])); % mDia vs control with LA
Figs(end+1,:) = scatter_and_histograms(comparison([13,10])); % TPM + KCl vs Control
%%
TAG='plot_';
for i = 1:length(Figs)
        print(Figs(i),'-depsc',['..\emulsions_plots\',TAG,Figs(i).Name]);
%         export_fig(['../',filename{i},'_exfig'],'-png','-m4',Fig(i));
end

%% oop
control_2017_01_31.filename = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_01_31\control 80percent_extract + LA-GFP\sample1\analysis_data_40m.mat',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_01_31\control 80percent_extract + LA-GFP\sample2\analysis_data_45m.mat'};
control_2017_01_31.description = 'control (31/01/17)';
control_2017_01_31.time = 45;
% control_2017_01_31.line = 3;
% control_2017_01_31.basename = 'analysis_data_';
control_2017_01_31 = load_plot_dirs(control_2017_01_31);

% control_2017_01_31_2.dirname = struct('name',...
%     {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_01_31\control 80percent_extract + LA-GFP\sample2'});
% control_2017_01_31_2.description = 'control (31/01/17) 2';
% control_2017_01_31_2.time = 45;
% control_2017_01_31_2.line = 1;
% control_2017_01_31_2.basename = 'analysis_data_';
% control_2017_01_31_2 = load_plot_dirs(control_2017_01_31_2);
% scatter_and_histograms_oop([control_2017_01_31,control_2017_01_31_2]);

