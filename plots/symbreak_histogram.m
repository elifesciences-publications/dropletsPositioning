function Fig = symbreak_histogram(plot_parameters)
blobRThetaPhiNormalized = [plot_parameters.BV.blobRThetaPhiNormalized];
symbraking = blobRThetaPhiNormalized(1,:);
Fig = histogram(symbraking,[0:0.1:0.9,1.3]);
xlim([0,1])
xlabel('Symmetry Breaking $\frac{r_{blob}}{R_{eff}}$','interpreter','latex')
ylabel('count');
end
