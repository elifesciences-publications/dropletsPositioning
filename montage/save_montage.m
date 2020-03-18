function Montage = save_montage(PAR)
% PAR = read_par(params_file);
BRIGHTFIELD_CHANNEL = 1;
if isfield(PAR,'FILTERS')
    stack = load_tiff_dir(PAR.DIRNAME , PAR.SCALEFACTOR,PAR.FILTERS{:});
    BRIGHTFIELD_CHANNEL = length(PAR.FILTERS);
else
    stack = load_tiff_dir(PAR.DIRNAME , PAR.SCALEFACTOR);
end
Montage = generate_montage(stack,PAR.N,PAR.M,PAR.LINEOFFX,PAR.COLOFFX,PAR.LINEOFFY,PAR.COLOFFY);
clear stack;
display(BRIGHTFIELD_CHANNEL);
if isfield(PAR, 'NAME') && ischar(PAR.NAME)
% if nargin > 1 && ischar(varargin{1})
    Mfile = fullfile(PAR.DIRNAME,PAR.NAME);
    Tfile = [Mfile,'.tiff'];
    save(Mfile,'Montage','-v7.3');
    for plain=1:length(Montage) 
        if(plain == 1)
            imwrite(Montage{BRIGHTFIELD_CHANNEL,plain},Tfile);
        else
            imwrite(Montage{BRIGHTFIELD_CHANNEL,plain},Tfile,'WriteMode','append');
        end
    end
end
