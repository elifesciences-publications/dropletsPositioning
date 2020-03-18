function [pks,locs,w,p] = findCorrPeak(C)
[pks,locs,w,p] = findpeaks(C(end,:),'SortStr','descend');
pks = pks(1) ;locs = locs(1) ;w = w(1) ;p = p(1);
end