function [ ] = detect_lines( image )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

bw= rgb2gray(image);
bw = edge(bw, 'Canny');

[H,T,R] = hough(bw);

P  = houghpeaks(H,10,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(bw,T,R,P,'FillGap',30,'MinLength',10);

figure

imshow(image)
hold on
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
end
hold off
end

