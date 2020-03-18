function [SDATA, SBDATA, indicesI, indicesL] = seperateSymbreaking(CCDATA)
    SBDATA = [];
    SDATA = [];
    for ind = 1:numel(CCDATA)
        sb = CCDATA(ind).Orig.r./CCDATA(ind).dropRadius;
        vv = [0,CCDATA(ind).Orig.Vr(1:end-1).*CCDATA(ind).Orig.Vr(2:end)];
%         rv = CCDATA(ind).Orig.r.*CCDATA(ind).Orig.VrSmooth;
        [maxSB,ILast] = max(sb);
        ILast = find(sb >= 0.97*maxSB,1);
        lastClose = find(sb<0.05,1, 'last');
        if isempty(lastClose)
            lastClose=1;
        end
        [~, maxVVInd] = max(vv(lastClose:ILast));
        maxVVInd = maxVVInd + lastClose - 1;
%         minVVInd = find(vv(lastClose(1):maxVVInd)<0,1,'last');
% %         [~, minVVInd] = min(vv(lastClose:maxVVInd));
%         minVVInd = minVVInd + lastClose - 1;
%         if isempty(minVVInd)
%             IFirst = lastClose;
%         else
%             IFirst = minVVInd;
%         end

%         [~,minVInd] = min(CCDATA(ind).Orig.Vr(lastClose:maxVVInd));
        minVInd = find(CCDATA(ind).Orig.VrSmooth(lastClose:maxVVInd)<0,1,'last');
        minVInd = minVInd + lastClose - 1;
        if isempty(minVInd)
            IFirst = lastClose;
        else
            IFirst = minVInd;
        end

%         IFirsts = [IFirsts, find(rv(IFirsts(1):ILast)>10,1)];
%         if length(IFirsts) < 2
%             IFirsts(2)=1;
%         end
        if isempty(IFirst) || IFirst == 1
            IFirst=1;
        else
            SDATA = [SDATA, truncate(CCDATA(ind),1:IFirst)];
        end
        SBDATA = [SBDATA, truncate(CCDATA(ind),IFirst:ILast)];
        indicesI(ind) = IFirst;
        indicesL(ind) = ILast;
    end
