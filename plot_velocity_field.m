calibration = 1/0.4055; % um per pixel
time_interval = 0.240 % seconds per frame
x = (1:size(vx_array,2))*calibration*16;
y = (1:size(vx_array,1))*calibration*16;
vx_cell = reshape(u_filtered,1,1,[]);
vy_cell = reshape(v_filtered,1,1,[]);
vx_array =cell2mat(vx_cell)*calibration/time_interval;
vy_array =cell2mat(vy_cell)*calibration/time_interval;
vx_mean = mean(vx_array,3,'omitnan');
vy_mean = mean(vy_array,3,'omitnan');
figure; quiverc(x,y,vx_mean,vy_mean);