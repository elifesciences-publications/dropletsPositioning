fid = fopen('list_maya.txt');
list = textscan(fid,'%s','Delimiter','\n');
fclose(fid);
list = list{1};
ind = view_kymographs(list)
%ind = [0    47    43    41    34    28    17     6     3]