function [msdVec,stdVec] = msd_vec(vec1,vec2,factor)
% MSD_VEC
% function [msdVec,stdVec] = msd_vec(vec1,vec2,factor)
%
% calcuate MSD for track (x,y), up to distances of 1/factor
% of total track length.
% returns MSD and standard deviation vectors.
N = length(vec1);
Nh = floor(length(vec1)/factor);
displacement_matrix = nan(N-1,Nh-1);
if exist('vec2','var')
    if length(vec1) ~= length(vec2)
        error('vector lengths differ');
    end
    for i=1:Nh-1
        Ni = N-i;
        for j=1:(i+1):Ni
            displacement_matrix(j,i) = (vec1(j+i) - vec1(j))^2 + ...
                                             (vec2(j+i) - vec2(j)).^2;
        end
    end

else
    for i=1:Nh-1
        Ni = N-i;
        for j=1:(i+1):Ni
            displacement_matrix(j,i) = (vec1(j+i) - vec1(j)).^2;
        end
    end
end
msdVec = [0,mean(displacement_matrix,'omitnan')];
stdVec = [0,std(displacement_matrix,'omitnan')./sqrt(sum(~isnan(displacement_matrix)))];

end