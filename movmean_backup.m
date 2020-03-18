function M = movmean_backup(A, k)
    for i=1:length(A)
        indLow = max(1, i - floor(k/2));
        indHigh = min(length(A), i + floor((k-0.5)/2));
        M(i) = mean(A(indLow:indHigh));
    end
end