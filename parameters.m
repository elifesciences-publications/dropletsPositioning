SCALEFACTOR = 0.5;
PARAMS = struct('DIRNAME', 'D:\Niv\montages\1\', 'SCALEFACTOR', SCALEFACTOR, 'N', 8,...
    'M', 7,'LINEOFFX', round(-25*SCALEFACTOR), 'COLOFFX', round(-155*SCALEFACTOR),...
    'LINEOFFY', round(-100*SCALEFACTOR), 'COLOFFY', round(35*SCALEFACTOR),...
    'PADDING', 75*SCALEFACTOR);
%
PARAMS(2).DIRNAME = 'D:\Niv\montages\2016_03_10\80% extract, 2mM MgCl_2, 0 actin\smaple 1, mix 1, time 10_40\capture 3\';
PARAMS(2).SCALEFACTOR = 0.5;
PARAMS(2).N = 8;
PARAMS(2).M = 5;
PARAMS(2).LINEOFFX = round(-25*SCALEFACTOR);
PARAMS(2).COLOFFX = round(-155*SCALEFACTOR);
PARAMS(2).LINEOFFY = round(-100*SCALEFACTOR);
PARAMS(2).COLOFFY = round(35*SCALEFACTOR);
PARAMS(2).PADDING = 75*SCALEFACTOR;
%
PARAMS(3).DIRNAME = 'D:\Niv\montages\2016_03_10\80% extract, 2mM MgCl_2, 0 actin\smaple 1, mix 1, time 10_40\capture 4\';
PARAMS(3).SCALEFACTOR = 0.5;
PARAMS(3).N = 8;
PARAMS(3).M = 5;
PARAMS(3).LINEOFFX = round(-25*SCALEFACTOR);
PARAMS(3).COLOFFX = round(-155*SCALEFACTOR);
PARAMS(3).LINEOFFY = round(-100*SCALEFACTOR);
PARAMS(3).COLOFFY = round(35*SCALEFACTOR);
PARAMS(3).PADDING = 75*SCALEFACTOR;
%
PARAMS(4).DIRNAME = 'Z:\analysis\Niv\montages\2016_03_10\80% extract, 6mM MgCl_2, 0 actin\sample 1, mix 1, time 13_15\capture 2\';
PARAMS(4).SCALEFACTOR = 0.5;
PARAMS(4).N = 7;
PARAMS(4).M = 7;
PARAMS(4).LINEOFFX = round(-25*SCALEFACTOR);
PARAMS(4).COLOFFX = round(-155*SCALEFACTOR);
PARAMS(4).LINEOFFY = round(-100*SCALEFACTOR);
PARAMS(4).COLOFFY = round(35*SCALEFACTOR);
PARAMS(4).PADDING = 75*SCALEFACTOR;
%
PARAMS(5).DIRNAME = 'Z:\analysis\Niv\montages\2016_03_10\80% extract, 6mM MgCl_2, 0 actin\sample 2, mix 1, time 14_20\capture 3\';
PARAMS(5).SCALEFACTOR = 0.5;
PARAMS(5).N = 8;
PARAMS(5).M = 8;
PARAMS(5).LINEOFFX = round(-25*SCALEFACTOR);
PARAMS(5).COLOFFX = round(-155*SCALEFACTOR);
PARAMS(5).LINEOFFY = round(-100*SCALEFACTOR);
PARAMS(5).COLOFFY = round(35*SCALEFACTOR);
PARAMS(5).PADDING = 75*SCALEFACTOR;
%
PARAMS(6).DIRNAME = 'Z:\analysis\Niv\montages\2016_03_10\80% extract, 6mM MgCl_2, 0 actin\sample 2 mix 2, time 16_15\capture 4\';
PARAMS(6).SCALEFACTOR = 0.5;
PARAMS(6).N = 7;
PARAMS(6).M = 7;
PARAMS(6).LINEOFFX = round(-25*SCALEFACTOR);
PARAMS(6).COLOFFX = round(-155*SCALEFACTOR);
PARAMS(6).LINEOFFY = round(-100*SCALEFACTOR);
PARAMS(6).COLOFFY = round(35*SCALEFACTOR);
PARAMS(6).PADDING = 75*SCALEFACTOR;

PARAMS(7).DIRNAME = 'Z:\analysis\Niv\montages\2016_03_07\mayas extract (rambam 4-1) 80%, 0 actin\sample1, mix1, time 13_15\capture 7\';
PARAMS(7).SCALEFACTOR = 0.5;
PARAMS(7).N = 8;
PARAMS(7).M = 7;
PARAMS(7).LINEOFFX = round(-25*SCALEFACTOR);
PARAMS(7).COLOFFX = round(-155*SCALEFACTOR);
PARAMS(7).LINEOFFY = round(-100*SCALEFACTOR);
PARAMS(7).COLOFFY = round(35*SCALEFACTOR);
PARAMS(7).PADDING = 75*SCALEFACTOR;
PARAMS(8) = read_par('Z:/analysis/Niv/montages/2016_04_19/80% extract, 0Mg, 0 actin/capture 1/params.txt');
PARAMS(9) = read_par('Z:/analysis/Niv/montages/2016_04_19/80% extract, 0Mg, 0 actin/capture 3/params.txt');
PARAMS(10) = read_par('Z:/analysis/Niv/montages/2016_04_25/60percent_0Mg/mix1_sample1_time11_30/capture_2/params.txt');
PARAMS(11) = read_par('Z:/analysis/Niv/montages/2016_06_07/80P_30c/params.txt');
PARAMS(12) = read_par('Z:/analysis/Niv/montages/2016_06_20/80P_24c/params.txt');
PARAMS(13) = read_par('Z:/analysis/Niv/montages/2016_06_19/40P_beads_24c/params.txt');
PARAMS(14) = read_par('Z:/analysis/Niv/montages/2016_06_19/40P_beads_30c/params.txt');
PARAMS(15) = read_par('Z:/analysis/Niv/montages/2016_07_05/40P_BSA-beads_24c/params.txt');
PARAMS(16) = read_par('Z:/analysis/Niv/montages/2016_07_05/40P_BSA-beads_30c/params.txt');
PARAMS(17) = read_par('Z:/analysis/Niv/montages/2016_07_12/40P_BSA-beads_24c/params.txt');
PARAMS(18) = read_par('Z:/analysis/Niv/montages/2016_07_12/40P_BSA-beads_30c/params.txt');%Bad smaple, no contraction
PARAMS(19) = read_par('Z:/analysis/Niv/montages/2016_07_13/40P_BSA-beads_24c/params.txt');
PARAMS(20) = read_par('Z:/analysis/Niv/montages/2016_07_13/40P_BSA-beads_30c/params.txt');


