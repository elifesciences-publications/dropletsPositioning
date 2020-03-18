function copyStruct(sNew, s)
if ~isstruct(s)
    sNew = s;
else
    FNs = fieldnames(s)
    for i=1:numel(FNs)
        FN = FNs(i);
        sNew.(FN) = copyStruct(s.(FN));
    end
end