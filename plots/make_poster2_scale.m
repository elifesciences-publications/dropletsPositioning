function make_poster2_scale(DIR)
r = (0:0.01:1)';
c_map = [r,1 - r,0*r]*2/3;
D = 'TPM31';
poster = imread(fullfile(DIR,'poster images\poster-scalebar.png'));
figure;
imshow(poster)
colormap(c_map)
c = colorbar('southoutside');
c.Label.String = '$\frac{r}{R_{effective}}$';
c.Label.Interpreter = 'Latex';
c.FontSize = 14;
print('-depsc',fullfile(DIR,'poster images\',['poster-scalebar.eps']));
