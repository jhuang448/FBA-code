function newpath = buildPathForPlot(path)
newpath = size(path(end,2), 2);
p = 1;
newpath(1:path(1,2)-1, 1) = path(1,1);
newpath(1:path(1,2)-1, 2) = [1:path(1,2)-1];
for i=2:size(path, 1)
    newpath(path(i-1,2):path(i,2)-1, 1) = path(i-1,1);
    newpath(path(i-1,2):path(i,2)-1, 2) = [path(i-1,2):path(i,2)-1];
end
newpath(path(end, 2), 1) = path(end,1);
newpath(path(end, 2), 2) = path(end,2);