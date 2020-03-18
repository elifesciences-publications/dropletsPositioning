function print_montage(filename)
load(filename);
if exist('Montage','var')
   Fig = imshow(Montage{1,1});
   saveas(Fig,'/user_temp/nivieru/montage_test','epsc');
   close Fig
end
end
