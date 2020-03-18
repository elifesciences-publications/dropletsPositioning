function [ HPimage ] = highPass( image, cutoff)
F =fft2(image);
s = size(F);
Rsqrd= (s*s')*cutoff;
[Kx,Ky] = meshgrid(1:s(2),1:s(1));
c_mask = ((Kx.^2+Ky.^2) <= Rsqrd);
FHighPass = F.*~c_mask;
HPimage = imadjust(real(ifft2(FHighPass)));
end