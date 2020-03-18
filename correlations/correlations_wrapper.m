function correlations_wrapper(filename,plane)
    [DIR,fname,ext] = fileparts(filename)
    DIR
    fname
    load(filename);
    length(drops)
    do_correlations(drops,plane,1);
    save(fullfile(DIR,[fname,'_correlation']),'drops','-v7.3')
end
