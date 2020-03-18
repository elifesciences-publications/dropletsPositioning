for i=1:(length(drops)-1)
    for j=(i+1):length(drops)
        if(strcmp(drops(i).originFile,drops(j).originFile))
            display(sprintf('%d %d %f',i,j,norm(drops(i).location - drops(j).location)));
        end
    end
end