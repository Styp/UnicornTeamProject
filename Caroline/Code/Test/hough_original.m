template = imread('detect_shap_code/triangle.png');
template = imresize(template,0.6);
originalImage = imread('Test1-1.jpg');
originalImage = imresize(originalImage,0.3);
%originalImage = imresize(originalImage,0.75);
%image = originalImage;
% Converting to grayscale.
grayTemplate = rgb2gray(template);
grayImage = rgb2gray(originalImage);



%% detect which preprocessing yields the best results!

%blurring the picture to reduce noise, we use the mean filter on a 5x5 
%neighborhood.
%h = ones(5,5) / 25;


%image = imfilter(grayImage,h);
%image = imfilter(image,h);

%use histogram equailzation and gamma transform to obtain a higher contrast
%image = histeq(image);
%image = im2double(image).^0.8;
%image = histeq(image);

% sharpening for better edge detection 
%image = imsharpen(image);
%image = imsharpen(image);


%% edge detection 
%image = imresize(image,0.1);
%grayTemplate = imresize(grayTemplate,0.2);
% Using Canny to find edges. Note that it converts the image into binary.
edgeTemplate = edge(grayTemplate, 'canny',[0.005, 0.5]);
%edge detection
%image = edge(image, 'Canny',[0.005, 0.5]);
edgeImage = edge(grayImage, 'canny',[0.005, 0.5]);
figure
imshow(edgeTemplate);
figure 
imshow(edgeImage);

%% build look up table

[x,y] = find (edgeTemplate > 0);
% x to the right and y downwards.
% Finding all the edge points in the template. (y1, x1), (y2, x2), ...
[numEdgePoints,~] = size(x);
% Number of edge points in the template.

%[refX, refY] = findCenter(edgeTemplate);

%define the center to be the center of the picture, makes it easier to
%detect the bounding box afterwards
sizeTemplate = size(edgeTemplate);
refX = round(sizeTemplate(1)/2);
refY = round(sizeTemplate(2)/2);

% Defining the referance point of the template (upper left corner).
% edgeTemplate must not be an RGB image. Then, size() will not work.

templateGradientMap = gradientDirection(edgeTemplate);
% Calculates a 2D-table showing the angle of the edge at each point.
figure
imshow(templateGradientMap, []);
%numbers of viewed angles
maxAngleBins = 10;
% How many angles do we want to discretize down to?
maxPointsPerAngle = numEdgePoints;
% The maximum number of vectors per angle is the number of edge points
% in the template.
pointCounter = zeros(maxAngleBins,1);
% Will be used to count the numberof vectors associated with an angle.
houghTable = zeros(maxAngleBins, maxPointsPerAngle, 2);
% Initializing the Hough table. We need a 3D-table because we want to
% have the x-values in one layer and the y-values in the other.
% -----TRAINING-----
% Looping through all the edge points. "edgePoint" is just an index.

for edgePoint = 1:1:maxPointsPerAngle
gradientAtPoint = templateGradientMap(x(edgePoint), y(edgePoint))/pi();
% Normalized into [0, 1].
binAngle = round(gradientAtPoint * (maxAngleBins - 1)) + 1;
% Tells us which bin the continuous angle at the point belongs to.
pointCounter(binAngle) = pointCounter(binAngle) + 1;
% Noting that this angle now wil point to one more vector.
% Filling the houghTable with the vector between the edge point
% and the reference point.
houghTable(binAngle, pointCounter(binAngle), 1) = refX - x(edgePoint);
houghTable(binAngle, pointCounter(binAngle), 2) = refY - y(edgePoint);
end
%% initialize the hough space

% Finding all the edge points in the image. (y1, x1), (y2, x2), ...
[x, y] = find(edgeImage > 0);
% Note that we are now overwriting the x�s and y�s of the template.
numEdgePoints = size(x);
% Again, overwriting the template�s variable.

imageGradientMap = gradientDirection(edgeImage);
figure
imshow(imageGradientMap, []);

imageSize = size(edgeImage);


%houghSpace = zeros(imageSize);
% Initializing the Hough Space, which has the same size as the image
% and is used to place votes.

stretch = 0.5:0.1:1.5;
[~ , numLayers] =  size(stretch);
%indicates the range of the size of the transformed image

houghSpace = zeros(imageSize(1),imageSize(2),numLayers);
%%
% ------RECOGNITION-----
for edgePoint = 1:1:numEdgePoints
gradientAtPoint = imageGradientMap(x(edgePoint), y(edgePoint))/pi();
binAngle = round(gradientAtPoint*(maxAngleBins - 1)) + 1;
% Discretizing the gradient at the edge point down to one of the bins.
% Looping through all the vectors associated with this particular bin
for vectorNum = 1:1:pointCounter(binAngle)
%run through all different stretching layers
for layer = 1:numLayers    
% Fetching the vector from the Hough Table and adding that to
% the position of the edge point
xVote = round(stretch(layer)* houghTable(binAngle, vectorNum, 1)) + x(edgePoint);
yVote = round(stretch(layer)* houghTable(binAngle, vectorNum, 2)) + y(edgePoint);
%xVote = houghTable(binAngle, vectorNum, 1) + x(edgePoint);
%yVote = houghTable(binAngle, vectorNum, 2) + y(edgePoint);

% What if we end up outside the boundaries of the image?
if xVote > 0 && xVote < imageSize(1) && yVote > 0 && yVote < imageSize(2)
houghSpace(xVote, yVote,layer) = houghSpace(xVote, yVote,layer) + 1;
% Incrementing the number of votes at the position the
% vector points to.
end
end
end
end
%%

%figure
%imshow(houghSpace)
% -----FETCHING SOME STATISTICS-----

% we run an 5x5 averaging filter over each layer
%initialize filter 
%h = ones(5,5,5) / 125;

%houghSpace(:,:) = imfilter(houghSpace(:,:),h); 
%maxValue
position=zeros(1,3);
%[position(1), position(2),position(3)] = findMaxArea(houghSpace);
% find the position of the larges element
[C,I] = max(houghSpace(:));
[position(1), position(2),position(3)] = ind2sub(size(houghSpace),I);


x = position(1) - stretch(position(3)) * sizeTemplate(1) /2;
y = position(2) - stretch(position(3)) * sizeTemplate(2) /2;
width_x =  stretch(position(3)) * sizeTemplate(1);
width_y = stretch(position(3)) * sizeTemplate(2);
%x = position(1) - sizeTemplate(1) /2;
%y = position(2) - sizeTemplate(2) /2;
%width_x =  sizeTemplate(1);
%width_y =  sizeTemplate(2) ;

boundingBox = [y,x,width_y,width_x];

figure 
imshow(originalImage)
rectangle('Position',boundingBox,'EdgeColor','r', 'LineWidth', 2)


%%

% Note that we overwrite x and y.
%Plotting the image with a marker at the spot we believe the figure is at.
%markerImage = insertMarker(image, [y, x], 'size', 15);
%imshow(markerImage);
% Finding the x�s and the y�s for the vectors in a specific bin and
% visualizing the result.
%xVecsBin8 = houghTable(8, :, 1);
%yVecsBin8 = houghTable(8, :, 2);
% Could probably do something cool with the plot below by not using

% zeros and lowering the number of vectors in order to make it more tidy.
%quiver(zeros(1, maxPointsPerAngle), zeros(1, maxPointsPerAngle),...
%yVecsBin8, -xVecsBin8 );
%bar(pointCounter, 20);
%imshow(log(houghSpace)), 