% bare extract vs CCA
[bare_CCA.dirs(1:5,1).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 1'...
    ,'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 2'}));
[bare_CCA.dirs(1:5,1).percent] = deal(80);
[bare_CCA.dirs(1:5,1).temp] = deal(24);
[bare_CCA.dirs(1:5,1).description] = deal('bare extract');

% [PARAMS(2,1,1:5).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_28\40extract 2muM_lifeact 100mu 1'}));
% [PARAMS(2,1,1:5).percent] = deal(40);
% [PARAMS(2,1,1:5).temp] = deal(24);
[bare_CCA.dirs(1:5,2).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample1 time09_55',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample2 time11_35'}));
[bare_CCA.dirs(1:5,2).percent] = deal(80);
[bare_CCA.dirs(1:5,2).temp] = deal(24);
[bare_CCA.dirs(1:5,2).description] = deal('CCA');

[bare_CCA.dirs([bare_CCA.dirs.percent] == 80).blobRfactor] = deal((0.7^2/15)^(1/3));
[bare_CCA.dirs([bare_CCA.dirs.percent] == 40).blobRfactor] = deal(0.1);

S = size(bare_CCA.dirs);
times = num2cell(repmat(linspace(0,60,size(bare_CCA.dirs,1))',1,S(2)));
[bare_CCA.dirs.time] = times{:};
basename = 'analysis_data_';
% times = linspace(0,60,length(bare_CCA.dirs));

bare_CCA.texts = {@(x) sprintf('%s',x.description), @(x) sprintf('%d min',x.time)};
% bare_CCA.legend_text = @(x,i) sprintf('%s, N=%d',bare_CCA.texts{i}(x), x.numDrops);
bare_CCA.Lmin = 15;
bare_CCA.Lmax = 100;


for i=1:S(1)
    for j = 1:(numel(bare_CCA.dirs)/S(1))
        ind = i + (j-1)*S(1);
        for l = 1:length(bare_CCA.dirs(ind).dirname)
            T = readtable(fullfile(bare_CCA.dirs(ind).dirname(l).name,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
            filename_suffix = table2cell(T(i,end));
            bare_CCA.dirs(ind).dirname(l).filename = [basename,filename_suffix{1}];
            %                 bare_CCA.dirs(i,j,k).time = times(k);
        end
    end
end
[bare_CCA.dirs([bare_CCA.dirs.percent] == 80).blobRfactor] = deal((0.7^2/15)^(1/3));
[bare_CCA.dirs([bare_CCA.dirs.percent] == 40).blobRfactor] = deal(0.1);

bare_CCA = load_plot_dirs( bare_CCA );
Figs = scatter_and_histograms(bare_CCA);
%%
% bare extract vs ActA
[bare_ActA.dirs(1,1).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 1'...
    ,'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 2'}));
[bare_ActA.dirs(1,1).percent] = deal(80);
[bare_ActA.dirs(1,1).temp] = deal(24);
[bare_ActA.dirs(1,1).description] = deal('bare extract');
% [PARAMS(2,1,1:5).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_28\40extract 2muM_lifeact 100mu 1'}));
% [PARAMS(2,1,1:5).percent] = deal(40);
% [PARAMS(2,1,1:5).temp] = deal(24);
[bare_ActA.dirs(1,2).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP ActA'}));
[bare_ActA.dirs(1,2).percent] = deal(80);
[bare_ActA.dirs(1,2).temp] = deal(24);
[bare_ActA.dirs(1,2).description] = deal('ActA');

[bare_ActA.dirs([bare_ActA.dirs.percent] == 80).blobRfactor] = deal((0.7^2/15)^(1/3));
[bare_ActA.dirs([bare_ActA.dirs.percent] == 40).blobRfactor] = deal(0.1);

S = size(bare_ActA.dirs);
times = {60,60};
[bare_ActA.dirs.time] = times{:};
basename = 'analysis_data_';
% times = linspace(0,60,length(bare_ActA.dirs));

bare_ActA.texts = {@(x) sprintf('%s',x.description), @(x) sprintf('%d min',x.time)};
% bare_ActA.legend_text = @(x,i) sprintf('%s, N=%d',bare_ActA.texts{i}(x), x.numDrops);
bare_ActA.Lmin = 15;
bare_ActA.Lmax = 100;

for m = 1:length(bare_ActA.dirs(1,1).dirname)
    T = readtable(fullfile(bare_ActA.dirs(1,1).dirname(m).name,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
    filename_suffix = table2cell(T(5,end));
    bare_ActA.dirs(1,1).dirname(m).filename = [basename,filename_suffix{1}];
end
T = readtable(fullfile(bare_ActA.dirs(1,2).dirname(1).name,'filters.txt'),'Delimiter',' ','ReadVariableNames',false);
filename_suffix = table2cell(T(1,end));
bare_ActA.dirs(1,2).dirname(1).filename = [basename,filename_suffix{1}];


[bare_ActA.dirs([bare_ActA.dirs.percent] == 80).blobRfactor] = deal((0.7^2/15)^(1/3));
[bare_ActA.dirs([bare_ActA.dirs.percent] == 40).blobRfactor] = deal(0.1);

bare_ActA = load_plot_dirs( bare_ActA );
Figs = scatter_and_histograms(bare_ActA);
%%
% bare extract vs TPM3.1
[bare_TPM3_1.dirs(1:5,1).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 1'...
    ,'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 2'}));
[bare_TPM3_1.dirs(1:5,1).description] = deal('bare extract');

[bare_TPM3_1.dirs(1:5,2).dirname] = deal(struct('name',...
    {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 3.3muM_TPM3.1'}));
[bare_TPM3_1.dirs(1:5,2).description] = deal('TPM3.1');

S = size(bare_TPM3_1.dirs);

bare_TPM3_1 = load_plot_dirs( bare_TPM3_1 );
Figs = scatter_and_histograms(bare_TPM3_1);
%%
% cof1 buffer vs CCA
N = 5;
[buffer_CCA.dirs(1:N,1).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_26\80percent_extract 0.5muM_LA-GFP buffer-cof1\mix2 sample1 time13_10'}));
[buffer_CCA.dirs(1:N,1).description] = deal('cof1 buffer');

[buffer_CCA.dirs(1:N,2).dirname] = deal(struct('name',...
    {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample1 time09_55',...
    'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_30\80P_extract Cor+Cof_AIP1 LA-GFP\mix1 sample2 time11_35'}));
[buffer_CCA.dirs(1:N,2).description] = deal('CCA');

buffer_CCA = load_plot_dirs( buffer_CCA );
Figs = scatter_and_histograms(buffer_CCA);
%%
% bare extract vs 10muM TPM3.1
N = 5;
[bare_10TPM3_1.dirs(1:N,1).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 1'...
    ,'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 2'}));
[bare_10TPM3_1.dirs(1:N,1).description] = deal('bare extract');
[bare_10TPM3_1.dirs(1:N,2).dirname] = deal(struct('name',...
    {'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_27\80percent_extract 0.5muM_LA-GFP 10muM_TPM3.1'}));
[bare_10TPM3_1.dirs(1:N,2).description] = deal('10muM TPM3.1');
bare_10TPM3_1 = load_plot_dirs( bare_10TPM3_1 );
Figs = scatter_and_histograms(bare_10TPM3_1);
%%
% bare extract vs cof1 buffer
lines = 1:5;
N = length(lines);

[bare_buffer.dirs(1:N,1).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 1'...
    ,'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_09_27\80extract 2muM_lifeact 100mu 2'}));
[bare_buffer.dirs(1:N,1).description] = deal('bare extract');
[bare_buffer.dirs(1:N,2).dirname] = deal(struct('name',{'Z:\analysis\Niv\rambam5 extract\symmetry breaking analysis\2016_10_26\80percent_extract 0.5muM_LA-GFP buffer-cof1\mix2 sample1 time13_10'}));
[bare_buffer.dirs(1:N,2).description] = deal('cof1 buffer');

bare_buffer = load_plot_dirs( bare_buffer ,lines);
Figs = scatter_and_histograms(bare_buffer);