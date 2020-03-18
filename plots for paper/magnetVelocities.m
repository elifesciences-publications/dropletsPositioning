buf1 = 100;
buf2 = 50;
velocities = arrayfun(@(C) C.Rot.VrSmooth(C.lastMagnetFrame+buf1:end-buf2),CCData,'UniformOutput',false);
v = horzcat(velocities{:});
displacements = arrayfun(@(C) C.Rot.rSmooth(C.lastMagnetFrame+buf1:end-buf2),CCData,'UniformOutput',false);
d = horzcat(displacements{:});
radiuses = arrayfun(@(C) C.dropRadius(C.lastMagnetFrame+buf1:end-buf2),CCData,'UniformOutput',false);
r = horzcat(radiuses{:});

figure; scatter(d,-v.*r.^2);
figure; scatter(d,-v);
figure; scatter(d,-v./r);
figure; scatter(d,-v./r.^2);
figure; scatter(d,-v./r.^3);

figure;histogram(v./d)
xlim([-2.5,2])
figure;histogram(v./d./r.^2*mean(r)^2)
xlim([-2.5,2])

xlim([-14,14]);
figure;histogram(v)
xlim([-14,14]);
