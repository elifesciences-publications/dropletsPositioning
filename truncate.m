function Data = truncate(Data, indices, L)
    if ~exist('L', 'var') || L<=0
        L = numel(Data.times);
    end
    fields = fieldnames(Data);
    for i=1:length(fields)
        f=fields{i};
        if length(Data.(f)) == L
            Data.(f) = Data.(f)(indices);
        elseif isstruct(Data.(f))
            Data.(f) = truncate(Data.(f), indices, L);
        end
    end
end