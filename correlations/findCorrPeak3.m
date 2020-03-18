function [pks,wr,wc] = findCorrPeak3(C)
[~,I] = max(C(:));
[row,col] = ind2sub(size(C),I);
cr = C(row,:);
cc = C(:,col);
[pksr,~,wr,~] = findpeaks(cr,'SortStr','descend');
pksr = pksr(1);
wr = wr(1);
[pksc,~,wc,~] = findpeaks(cc,'SortStr','descend');
wc = wc(1);
pks = pksr;
end