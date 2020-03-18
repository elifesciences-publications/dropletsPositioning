control.filename = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample1\analysis_data_montage40m_oop.mat',...
    'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_22\control 80percent_extract + XB +LA-GFP-Emix\sample2\analysis_data_montage40m_oop',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_01_31\control 80percent_extract + LA-GFP\sample1\analysis_data_40m.mat',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2017_01_31\control 80percent_extract + LA-GFP\sample2\analysis_data_45m.mat'};
control.description='control';
control.time = 40;
control = load_plot_dirs(control,false);

ActA.filename = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP ActA\analysis_data_montage60m_oop.mat'};
ActA.description = 'ActA';
ActA.time = 60;
ActA = load_plot_dirs(ActA,false);

AbpSrv.filename = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_07\Srv2_2muM+Abp1_2muM\analysis_data_montage40m_oop.mat'};
AbpSrv.description = '2muM Abp1 + Srv2';
AbpSrv.time = 40;
AbpSrv = load_plot_dirs(AbpSrv,false);

ActAAbpSrv.filename = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_07\ActA+srv2+Abp1\analysis_data_montage40m_oop.mat'};
ActAAbpSrv.description = 'ActA + Abp1 + Srv2';
ActAAbpSrv.time = 40;
ActAAbpSrv = load_plot_dirs(ActAAbpSrv,false);

CCA.filename = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample1 time09_55\analysis_data_montage45m_oop.mat',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample2 time11_35\analysis_data_montage45m_oop.mat'};
CCA.description = 'CCA';
CCA.time = 45;
CCA = load_plot_dirs(CCA,false);

TPM31.filename = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 3.3muM_TPM3.1\analysis_data_montage45m_oop.mat'};
TPM31.description = 'TPM3.1';
TPM31.time = 45;
TPM31 = load_plot_dirs(TPM31,false);

TPM31KCl.filename = {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_11_01\3muM_TPM3.1 30mM_KCl\analysis_data_montage45m_oop.mat'};
TPM31KCl.description = 'TPM3.1 + KCl';
TPM31KCl.time = 45;
TPM31KCl = load_plot_dirs(TPM31KCl,false);

mDia.filename = {'Z:\analysis\Niv\adams visit\symmetry breaking analysis\2016_12_11\mDia\sample1\analysis_data_montage40m_oop.mat'};
mDia.description = 'mDia';
mDia.time = 40;
mDia = load_plot_dirs(mDia,false);
%%
scatter_plots_oop(control,[1,0,1]);
scatter_plots_oop(ActA,[1,0,1]);
scatter_plots_oop(AbpSrv,[1,0,1]);
scatter_plots_oop(ActAAbpSrv,[1,0,1]);
scatter_plots_oop(CCA,[1,0,1]);
scatter_plots_oop(TPM31,[1,0,1]);
scatter_plots_oop(TPM31KCl,[1,0,1]);
scatter_plots_oop(mDia,[1,0,1]);
%%
Figs(1,:) = scatter_plots_oop(control,[1,1,0]);
Figs(2,:) = scatter_plots_oop([control,ActA],[1,1,0]);
Figs(3,:) = scatter_plots_oop([control,AbpSrv],[1,1,0]);
Figs(4,:) = scatter_plots_oop([control,ActAAbpSrv],[1,1,0]);
Figs(5,:) = scatter_plots_oop([control,CCA],[1,1,0]);
Figs(6,:) = scatter_plots_oop([control,TPM31],[1,1,0]);
Figs(7,:) = scatter_plots_oop([TPM31KCl,TPM31],[1,1,0]);
Figs(8,:) = scatter_plots_oop([control,mDia],[1,1,0]);
%%
TAG='plot_large_font_';
for i = 1:numel(Figs)
        title(Figs(i).Children(2),'');
        print(Figs(i),'-depsc',['..\plots\emulsions_plots\',TAG,Figs(i).Name,'.eps']);
%         export_fig(['../',filename{i},'_exfig'],'-png','-m4',Fig(i));
end

%%
figure;
imshow(make_poster([control.DATA.drops],6,4,150));
c = colorbar('southoutside');
c.Label.String = '$\frac{r}{R_{effective}}$';
c.Label.Interpreter = 'Latex';
c.FontSize = 14;
% print('-depsc','..\plots\emulsions_plots\poster_control.eps');

