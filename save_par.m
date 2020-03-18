function save_par(PAR, filename)
FID = fopen(filename,'w');
fprintf(FID, '%f; %d; %d; %f; %f; %f; %f; %f',...
    PAR.SCALEFACTOR, PAR.N, PAR.M, PAR.LINEOFFX/PAR.SCALEFACTOR,...
    PAR.COLOFFX/PAR.SCALEFACTOR, PAR.LINEOFFY/PAR.SCALEFACTOR, PAR.COLOFFY/PAR.SCALEFACTOR, PAR.PADDING/PAR.SCALEFACTOR);
fclose(FID);
end
