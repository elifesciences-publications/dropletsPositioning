% bare extract
times = num2cell(0:15:60);
lines = num2cell(1:5);
[bare(1:5).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 1'...
    ,'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 2'}));
[bare(1:5).description] = deal('bare extract');
[bare(1:5).time] = deal(times{:});
[bare(1:5).line] = deal(lines{:});

% CCA
[CCA(1:5).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample1 time09_55',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample2 time11_35'}));
[CCA(1:5).description] = deal('CCA');
[CCA(1:5).time] = deal(times{:});
[CCA(1:5).line] = deal(lines{:});

% ActA
ActA.dirname = struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP ActA'});
ActA.description = 'ActA';

ActA.time = 60;
ActA.line = 1;

% TPM3.1
[TPM3_1(1:5).dirname] = deal(struct('name',...
    {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 3.3muM_TPM3.1'}));
[TPM3_1(1:5).description] = deal('TPM3.1');
[TPM3_1(1:5).time] = deal(times{:});
[TPM3_1(1:5).line] = deal(lines{:});

% cof1 buffer
[cofBuffer(1:5).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_26\80percent_extract 0.5muM_LA-GFP buffer-cof1\mix2 sample1 time13_10'}));
[cofBuffer(1:5).description] = deal('cof1 buffer');
[cofBuffer(1:5).time] = deal(times{:});
[cofBuffer(1:5).line] = deal(lines{:});

% cof1 buffer (E.mix+LAGFP)

[cofBuffer2(1:5).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract cof-buffer LA-GFP'}));
[cofBuffer2(1:5).description] = deal('cof1 buffer 2');
[cofBuffer2(1:5).time] = deal(times{:});
[cofBuffer2(1:5).line] = deal(lines{:});

% control G-buffer 

[Gbuffer(1:5).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_28\80percent_extract control G-buffer TPM-buffer'}));
[Gbuffer(1:5).description] = deal('G-buffer');
[Gbuffer(1:5).time] = deal(times{:});
[Gbuffer(1:5).line] = deal(lines{:});

% 10muM TPM3.1
[TPM31_10muM(1:5).dirname] = deal(struct('name',...
    {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 10muM_TPM3.1'}));
[TPM31_10muM(1:5).description] = deal('10muM TPM3.1');
[TPM31_10muM(1:5).time] = deal(times{:});
[TPM31_10muM(1:5).line] = deal(lines{:});

% TPM3.1 + ActA
N=2
[TPM31_ActA(1:N).dirname] = deal(struct('name',...
    {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 3muM_TPM3.1 + ActA'}));
[TPM31_ActA(1:N).description] = deal('TPM3.1 + ActA');
[TPM31_ActA(1:N).time] = deal(times{6-N:end});
[TPM31_ActA(1:N).line] = deal(lines{6-N:end});

% TPM3.1 + 30mM KCl
N=2
[TPM31_KCl(1:N).dirname] = deal(struct('name',...
    {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_11_01\3muM_TPM3.1 30mM_KCl'}));
[TPM31_KCl(1:N).description] = deal('TPM3.1 + 30muM KCl');
[TPM31_KCl(1:N).time] = deal(times{6-N:end});
[TPM31_KCl(1:N).line] = deal(lines{6-N:end});


%%
bare = load_plot_dirs( bare );
CCA = load_plot_dirs( CCA );
ActA = load_plot_dirs( ActA );
TPM3_1 = load_plot_dirs( TPM3_1 );
TPM31_10muM = load_plot_dirs( TPM31_10muM );
cofBuffer = load_plot_dirs( cofBuffer );
cofBuffer2 = load_plot_dirs( cofBuffer2 );
Gbuffer = load_plot_dirs( Gbuffer );
TPM31_ActA = load_plot_dirs( TPM31_ActA );
TPM31_KCl = load_plot_dirs( TPM31_KCl );

%%
Figs(1) = scatter_and_histograms([cofBuffer;CCA]'); % no difference
Figs(2) = scatter_and_histograms([bare(5);ActA]'); % ActA more symmetric
Figs(3) = scatter_and_histograms([cofBuffer;TPM3_1]'); % TPM3.1 more symmetric in small radius, less symmetric in large radius
Figs(4) = scatter_and_histograms([cofBuffer;TPM31_10muM]');% TPM3.1 less symmetric in large radius, low statistics
Figs(5) = scatter_and_histograms([bare;cofBuffer;cofBuffer2;Gbuffer]');% cof Buffer with E.mix+LAGFP anomaly?
Figs(6) = scatter_and_histograms([cofBuffer(4:5);TPM3_1(4:5);TPM31_ActA]');% TPM+ActA low statistics
Figs(7) = scatter_and_histograms([cofBuffer(4:5);TPM3_1(4:5);TPM31_KCl]');% TPM+KCl more broken symmetry in intermediate radius, no statistics in large radius

%%
filename = {'plot_CCA','plot_ActA','plot_TPM31','plot_10muM_TPM31','plot_controls'...
            ,'plot_TPM31_ActA','plot_TPM31_KCl'};
for i = 1:length(Figs)
    if i<=length(filename)
        print(Figs(i),'-dpng',['../',filename{i}]);
%         export_fig(['../',filename{i},'_exfig'],'-png','-m4',Fig(i));
    end
end
