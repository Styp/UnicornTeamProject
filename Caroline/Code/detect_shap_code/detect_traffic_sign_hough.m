function [ final_boundingBox, label, method ] = detect_traffic_sign_hough (originalImage, sign )
%this function receives an rgb image on which we will search for an traffic
%sign and a string defining that traffic sign. Possible inputs for sign are
% warning, stop, giveway, priority road. 
% The output is a bounding box around the found traffic sign, a label for
% the sign and a index determining the method. 
% The function than scales the image such that the it consists of a
% standardized x-lenght. 
% Then hough transform is used to detect the most likely refrence points
% where the sign is assumed. By setting how many bounding boxes we
% maximally want the function to return it returns that amount of bounding
% boxes if the number of votes of the refrence point is above a certain
% level. 

%% possible parameters
% remeber that if zou change parameters here that will also affect the
% number of vote, i.e. you will also have to change the threshold for 
% the different signs here

% label the method with the string to indicate what kind of sign was found 
%and what index is assigned to the method 
%method_label = 'give way'; will be set for every method individually
%method_index = 3;

% the standard size to which the x lenght of the input image is converted 
% to obtain faster and standardised computation
standard_size_x = 600;

%indicates the range of the size of form we are searching for in the image
stretch = 0.5:0.05:1.5;

%numbers of distinct viewed angles
maxAngleBins = 30; 		

%proportional size of the templated  we are searching for 
% compared to the original image
prop = 1/7;

% size of the averaging filter which is run over the hough space before 
%we extract the largest value
av = 3;

% indicates how many votes a pixel should have to indicate a warning sign
%threshold = 20; will be indicated for every method individually

% indicates how much results we want to be returned if they are greater
% than the threshold 
numReturns = 1;

%% decide which sign we are searching for 
% load the template and resize it to the given proportion of the input
% image
if strcmp(sign,'warning')
    template = imread('triangle.png');
    method_label = 'warning';
    method_index = 3;
    threshold = 20;

    
elseif strcmp(sign, 'giveway')
    template = imread('triangle.png');
    template = imrotate(template,180);
    method_label = 'warning';
    method_index = 3;
    threshold = 20;
    
elseif strcmp(sign,'stop')
    template = imread('stop.png');
    method_label = 'stop';
    method_index = 3;
    threshold = 50;

elseif strcmp(sign, 'priority road')
    template = imread('priority_road.png');
    method_label = 'priority_road';
    method_index = 3;
    threshold = 55;

else
    error('this is not a valid road sign, please use one of the following: warning, giveway, stop or priority road') 
end    
%template = imrotate(template,180);

%% preprocessing 

%resize original Image to a standarized size 
image = originalImage;
size_original_image = size(image);
resize_original = standard_size_x / size_original_image(1);
image = imresize(image,resize_original);



size_template = size(template);
resize = prop * standard_size_x/ size_template(1);
template = imresize(template,resize);


% convert both images into gray scale images
grayTemplate = rgb2gray(template);
grayImage = rgb2gray(image);


%% edge detection 

% Using Canny to find edges. Note that it converts the image into binary.
edgeTemplate = edge(grayTemplate, 'canny',[0.005, 0.5]);
edgeImage = edge(grayImage, 'canny',[0.005, 0.5]);

%figure
%imshow(edgeTemplate);
%figure 
%imshow(edgeImage);


%% build look up table with the template

%find all edge pixels in the template
[x,y] = find (edgeTemplate > 0); 

%number of edge pixels
[numEdgePoints,~] = size(x);

% we define the center of the template to be the refrence point
% this makes it easier to detect the bounding box afterwards
sizeTemplate = size(edgeTemplate);
refX = round(sizeTemplate(1)/2);
refY = round(sizeTemplate(2)/2);

% Calculates a 2D-table showing the angle of the edge at each point.
templateGradientMap = gradientDirection(edgeTemplate);

%figure
%imshow(templateGradientMap, []);


% The maximum number of vectors per angle is the number of edge points
% in the template 
maxPointsPerAngle = numEdgePoints;

% Will be used to count the number of vectors associated with an angle.
pointCounter = zeros(maxAngleBins,1);


% Initializing the Hough table in which we will save the vectors from the 
% edge point to the refrence point associated with the according angle.  
% We therefore use a 3D-table to save the to x-values in one layer and 
% the y-values in the other.
houghTable = zeros(maxAngleBins, maxPointsPerAngle, 2);

% Looping through all the edge points. "edgePoint" is just an index.
for edgePoint = 1:1:maxPointsPerAngle
    
% Normalize the gradiant angle into [0, 1].   
gradientAtPoint = templateGradientMap(x(edgePoint), y(edgePoint))/pi();

% Tells us in which bin the continuous angle at the point belongs to.
binAngle = round(gradientAtPoint * (maxAngleBins - 1)) + 1;

% Note that this angle now will point to one more vector.
pointCounter(binAngle) = pointCounter(binAngle) + 1;

% Filling the houghTable with the vector between the edge point
% and the reference point.
houghTable(binAngle, pointCounter(binAngle), 1) = refX - x(edgePoint);
houghTable(binAngle, pointCounter(binAngle), 2) = refY - y(edgePoint);
end


%% initialize the hough space

% Finding all the edge points in the image.
[x, y] = find(edgeImage > 0);
% Note that we are now overwriting some variables we introduced during 
% the building of the look up table 

%number of edge points
numEdgePoints = size(x);

% compute the gradiante image 
imageGradientMap = gradientDirection(edgeImage);

%figure
%imshow(imageGradientMap, []);

imageSize = size(image);


% the amount of different resizes of the template we are looking for
[~ , numLayers] =  size(stretch);

% Initializing the Hough Space, which has the same size as the image but
% three dimensional. The third dimension will be to distinct between
% different sizes of the searched template Testbilder/
% The hough space is used to place vote
houghSpace = zeros(imageSize(1),imageSize(2),numLayers);

%% place votes 

%iterate over all edge points in the image to place votes in the hough
%space
for edgePoint = 1:1:numEdgePoints

%normalized angle    
gradientAtPoint = imageGradientMap(x(edgePoint), y(edgePoint))/pi();
% Discretizing the gradient at the edge point down to one of the bins.
binAngle = round(gradientAtPoint*(maxAngleBins - 1)) + 1;

% Looping through all the vectors associated with this particular bin
for vectorNum = 1:1:pointCounter(binAngle)
    
%run through all different resizing layers
for layer = 1:numLayers    
    
    
% Fetching the vector from the Hough Table and adding that to the position
% of the edge point .
% We also need to use the resize factor to get the correct pixel to vote
% for
xVote = round(stretch(layer)* houghTable(binAngle, vectorNum, 1)) + x(edgePoint);
yVote = round(stretch(layer)* houghTable(binAngle, vectorNum, 2)) + y(edgePoint);

% make sure that we dont end outside the image
if xVote > 0 && xVote < imageSize(1) && yVote > 0 && yVote < imageSize(2)

% the vote depends on the strech of the template, as small figures will
% automatically get less votes than big ones, therefore fit the vote
% according to the amount of rescaling. 
houghSpace(xVote, yVote,layer) = houghSpace(xVote, yVote,layer) + ...
    1/stretch(layer);

end
end
end
end

%% decide and return bounding box

% we run an averaging filter over each layer
 
h = ones(av,av,av) / av^3;
houghSpace(:,:,:) = imfilter(houghSpace(:,:,:),h); 
%houghSpace(:,:) = imfilter(houghSpace(:,:),h); 



% initalize the return vectors 
boundingBox = [];
label = categorical();
method = [];

returns = 0;
% find the location and amount for the pixel with the most votes
pos=zeros(1,3);
[C,I] = max(houghSpace(:));
%C



while C > threshold && returns < numReturns
   %C 
[pos(1), pos(2),pos(3)] = ind2sub(size(houghSpace),I);

width_x =  floor(stretch(pos(3)) * sizeTemplate(1));
width_y = floor(stretch(pos(3)) * sizeTemplate(2));

x = pos(1) - floor(width_x/2); 
y = pos(2) - floor(width_x /2);


%check that the bounding box is not outside of the image
if  x < 1
    x = 1;
    width_x = width_x - abs(x);
    
elseif x + width_x > imageSize(1)  
    width_x = width_x - abs(x + width_x-imageSize(1)) -1;

elseif y < 1    
       y = 1;
    width_y = width_y - abs(x);
 
elseif y + width_y > imageSize(2)  
    width_y = width_y - abs(y + width_y -imageSize(1)) -1;
end

%include the resulting bounding box in the bounding box vector 
boundingBox = [boundingBox; ...
    y, x, width_y, width_x];

% count the returns of bounding boxes
returns = returns +1;

% set the label for this category 
label = categorical();
label(returns,1) = method_label;
method = [method;
    method_index];

% set the current maximum and all pixel in the bounding box equal to zero 
houghSpace(x:x+width_x,y:y+width_y,:) = 0;
[C,I] = max(houghSpace(:));

end

% Test show the picture
%figure
%imshow(image)
%hold on
%test_size = size(boundingBox);
%for i = 1 : test_size(1)
%rectangle('Position',boundingBox(i,:),'EdgeColor','r', 'LineWidth', 2)
%end


final_boundingBox = (1/resize_original) *boundingBox;


end