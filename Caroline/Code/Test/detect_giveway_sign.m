function [ boundingBox, lable ] = detect_giveway_sign (originalImage )
%this functions detects the warning signs in an image with the help of the
%hough transform

%check threshold and the vote structure!!!

%% possible parameters
%standard_size = [1000,1500];

%indicates the range of the size of the transformed image
stretch = 0.5:0.05:1.5;

% indicates how many votes a pixel should have to indicate a warning sign
threshold = 0;

%numbers of distinct viewed angles
maxAngleBins = 30;

%proprtional size of the sign compared to the original image
prop = 1/7;

% size of the averaging filter before getting the largest value
av = 3;
%% preprocessing 
template = imread('standardPictures/triangle.png');
template = imrotate(template,180);
%template = imresize(template,0.5);
%template = imread('standardPictures/triangle.png');
size_original_image = size(originalImage);
size_template = size(template);

resize = prop * ( size_original_image(1)/ size_template(1));

template = imresize(template,resize);

% resize the picture to a standarized size 
%image = imresize(originalImage, standard_size);
image = originalImage;

%resize_x = size(1)/standard_size(1);
%resize_y = size(2)/standard_size(2);

grayTemplate = rgb2gray(template);
grayImage = rgb2gray(image);
%grayImage = im2double(grayImage);
%grayImage = imfill(grayImage,'holes');
%grayImage = ordfilt2(grayImage,25,ones(5,5));

%% edge detection 

% Using Canny to find edges. Note that it converts the image into binary.
edgeTemplate = edge(grayTemplate, 'canny',[0.005, 0.5]);

edgeImage = edge(grayImage, 'canny',[0.005, 0.5]);

figure
imshow(edgeTemplate);
figure 
imshow(edgeImage);


%% build look up table

%find all edge pixels in the template
[x,y] = find (edgeTemplate > 0); 

%number of edge pixels
[numEdgePoints,~] = size(x);


%define the center to be the center of the picture, makes it easier to
%detect the bounding box afterwards
sizeTemplate = size(edgeTemplate);
refX = round(sizeTemplate(1)/2);
refY = round(sizeTemplate(2)/2);

% Calculates a 2D-table showing the angle of the edge at each point.
templateGradientMap = gradientDirection(edgeTemplate);

%figure
%imshow(templateGradientMap, []);



% The maximum number of vectors per angle is the number of edge points
% in the template is the maximal number of edge points
maxPointsPerAngle = numEdgePoints;

% Will be used to count the numberof vectors associated with an angle.
pointCounter = zeros(maxAngleBins,1);


%Initializing the Hough table. We need a 3D-table because we want to
% have the x-values in one layer and the y-values in the other.
houghTable = zeros(maxAngleBins, maxPointsPerAngle, 2);

% Looping through all the edge points. "edgePoint" is just an index.
for edgePoint = 1:1:maxPointsPerAngle
% Normalized the gradiant angle into [0, 1].   
gradientAtPoint = templateGradientMap(x(edgePoint), y(edgePoint))/pi();

% Tells us in which bin the continuous angle at the point belongs to.
binAngle = round(gradientAtPoint * (maxAngleBins - 1)) + 1;

% Noting that this angle now will point to one more vector.
pointCounter(binAngle) = pointCounter(binAngle) + 1;

% Filling the houghTable with the vector between the edge point
% and the reference point.
houghTable(binAngle, pointCounter(binAngle), 1) = refX - x(edgePoint);
houghTable(binAngle, pointCounter(binAngle), 2) = refY - y(edgePoint);
end


%% initialize the hough space

% Finding all the edge points in the image.
[x, y] = find(edgeImage > 0);
% Note that we are now overwriting the x’s and y’s of the template.

%number of edge points
numEdgePoints = size(x);
% Again, overwriting the template’s variable.

% compute the gradiante image 
imageGradientMap = gradientDirection(edgeImage);

%figure
%imshow(imageGradientMap, []);

imageSize = size_original_image;



%stretch = 0.5:0.1:1.5; introduced as a parameter

% the different number of resize we are looking for
[~ , numLayers] =  size(stretch);

% Initializing the Hough Space, which has the same size as the image but
% three dimensional. The third dimension will be to distinct between
% different sizes of the searched sign 
% The hough space is used to place vote
houghSpace = zeros(imageSize(1),imageSize(2),numLayers);

%% place votes 

%iterate over all edge points in the image
for edgePoint = 1:1:numEdgePoints

%normalized angle    
gradientAtPoint = imageGradientMap(x(edgePoint), y(edgePoint))/pi();
% Discretizing the gradient at the edge point down to one of the bins.
binAngle = round(gradientAtPoint*(maxAngleBins - 1)) + 1;

% Looping through all the vectors associated with this particular bin
for vectorNum = 1:1:pointCounter(binAngle)
%run through all different resizing layers
for layer = 1:numLayers    
% Fetching the vector from the Hough Table and adding that to
% the position of the edge point 
% we also need to use the resize factor to get the correct pixel to vote
% for
xVote = round(stretch(layer)* houghTable(binAngle, vectorNum, 1)) + x(edgePoint);
yVote = round(stretch(layer)* houghTable(binAngle, vectorNum, 2)) + y(edgePoint);

% make sure that we dont end outside the image
if xVote > 0 && xVote < imageSize(1) && yVote > 0 && yVote < imageSize(2)
%houghSpace(xVote, yVote,layer) = houghSpace(xVote, yVote,layer) + 1;

%try to give the same vote for small and big triangles
houghSpace(xVote, yVote,layer) = houghSpace(xVote, yVote,layer) + ...
    1/stretch(layer);

% Incrementing the number of votes at the position the
% vector points to.
end
end
end
end

%% decide and return bounding box

% we run an 5x5 averaging filter over each layer
%initialize filter 
h = ones(av,av,av) / av^3;
houghSpace(:,:) = imfilter(houghSpace(:,:),h); 

%find location of the larges pixel 
position=zeros(1,3);
[C,I] = max(houghSpace(:));
C

if C > threshold 
    
[position(1), position(2),position(3)] = ind2sub(size(houghSpace),I);



x = position(1) - stretch(position(3)) * sizeTemplate(1) /2; 
y = position(2) - stretch(position(3)) * sizeTemplate(2) /2;
width_x =  stretch(position(3)) * sizeTemplate(1);
width_y = stretch(position(3)) * sizeTemplate(2);


boundingBox = [y, x,...
    width_y, width_x];

% use the resize factor to obtain the right bounding box for the original
% picture
%boundingBox = [resize_y * y, resize_x * x,...
   % resize_y * width_y, resize_x*width_x];
lable = 'warning_sign';
figure 
imshow(image)
hold on
rectangle('Position',boundingBox,'EdgeColor','r', 'LineWidth', 2)
else
boundingBox = [];
lable = [];
end


end