function [x, y,s] = findMaxArea(houghSpace)
% Using a 3x3 grid to find the area where the intensity of the
% Hough Space is the highest.
[rows, cols,layers] = size(houghSpace);
maxIntensity = 0;
x = 0;
y = 0;
s = 0;
% Looping through the image.
for lay =  1:1:layers
for row = 1:1:(rows - 3)
for col = 1:1:(cols - 3)
accumulator = 0;
% Resetting the accumulator.
% Looping through the grid.
for gridRow = 1:3
for gridCol = 1:3
accumulator = accumulator +...
houghSpace(row + gridRow, col + gridCol,lay);
% Incrementing the accumulator by the value in this
% position at Hough Space.
end
end
% If this area is better than the previous best area.
if accumulator > maxIntensity
maxIntensity = accumulator;
% Updating where we think the object is (+1 comes from
% gridsize).
x = row + 1;
y = col + 1;
s = lay;
end
end
end
end
end