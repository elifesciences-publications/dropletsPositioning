DIR = 'Z:\analysis\Niv\montages\2016_04_25\60percent_0Mg\mix1_sample1_time11_30\capture_2';
PAR = read_par(fullfile(DIR,'params.txt'));
FILTER = {'T0*','T1*','T2*'};
FNAME = {'Montage_0m.mat','Montage_30m.mat','Montage_60m.mat'};
for i = 1:3
    stack = load_tiff_dir( DIR , PAR.SCALEFACTOR, FILTER{i});
    Montage = generate_montage(stack,PAR.N,PAR.M,PAR.LINEOFFX,PAR.COLOFFX,PAR.LINEOFFY,PAR.COLOFFY);
    clear stack;
    save(fullfile(DIR,FNAME{i}),'Montage','-v7.3');
    clear Montage;
end