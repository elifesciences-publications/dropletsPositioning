function [pks,locs,w,p] = findCorrPeak2(C)
c= C(floor(end/2) + 1,:);
[pks,locs,w,p] = findpeaks(c,'SortStr','descend');
pks = pks(1) ;locs = locs(1) ;w = w(1) ;p = p(1);
end