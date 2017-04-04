clear();
clc();

base_dir = 'Training';

M = readtable('Training/00021/GT-00021.csv');

length = size(M);
positiveImages = [];
for k=1:length(1,1)
   positiveImages(k).imageFilename = M{k,1};
      
   %format [x y width height] 
   positiveImages(k).objectBoundingBoxes = [M{k,5},M{k,4},M{k,7}-M{k,5},M{k,6}-M{k,4}];
end
positiveImagesTable = struct2table(positiveImages);

% Add the image directory to the MATLAB path.
imDir = 'Training/00021/';
addpath(imDir);

%%
% Create an |imageDatastore| object containing negative images.
negativeImgDir = 'NonTSImages/TestingBG/'
negativeImages = imageDatastore(negativeImgDir);

%% Train the detector
trainCascadeObjectDetector('detector.xml',positiveImagesTable, ...
    negativeImgDir,'FalseAlarmRate',0.1,'NumCascadeStages',5);

%%
% Use the newly trained classifier to detect a stop sign in an image.
detector = vision.CascadeObjectDetector('detector.xml');
%%
% Read the test image.
img = imread('stopSignTest.jpg');
%%
% Detect a stop sign.
bbox = step(detector,img); 
%%
% Insert bounding box rectangles and return the marked image.
 detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');
%%
% Display the detected stop sign.
figure; imshow(detectedImg);

