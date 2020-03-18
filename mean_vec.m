function meanVec = mean_vec(vec1)
N = length(vec1);
displacement_matrix = nan(N-1);

for i=1:N-1
    Ni = N-i;
    for j=1:Ni
        displacement_matrix(i,j) = vec1(j+i) - vec1(i);
    end
end
meanVec = [0,mean(displacement_matrix,'omitnan')];
end
