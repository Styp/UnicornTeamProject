clear();
clc();

data_dir = 'Data/'

M = readtable('genericTrainingData.txt');

length = size(M);
i = 1;
positiveImages = [];

for k=1:1000
%for k=1:length(1,1)
    x1 = M{k,2};
    y1 = M{k,3};
    x2 = M{k,4};
    y2 = M{k,5};

    if (x1 >= 1) && (y1 >= 1) && (x2 >= 1) && (y2 >= 1)
       positiveImages(i).imageFilename = strcat(data_dir,M{k,1});
  
       %format [x y width height]
       positiveImages(i).objectBoundingBoxes = [x1,y1,x2-x1,y2-y1];
       i = i+1;
   end
end

positiveImagesTable = struct2table(positiveImages);
%%
% Create an |imageDatastore| object containing negative images.
negativeImgDir = 'NonTSImages/TestingBG/'
negativeImages = imageDatastore(negativeImgDir);

%% Train the detector
trainCascadeObjectDetector('detector.xml',positiveImagesTable, ...
   negativeImgDir,'FalseAlarmRate',0.1,'NumCascadeStages',10);

%%
% Use the newly trained classifier to detect a stop sign in an image.
%detector = vision.CascadeObjectDetector('detector.xml');
%%
% Read the test image.
img = imread('stopSignTest.jpg');
%%
% Use the newly trained classifier to detect a stop sign in an image.
detector = vision.CascadeObjectDetector('detector.xml');
%%
% Detect a stop sign.
bbox = step(detector,img); 
%%
% Insert bounding box rectangles and return the marked image.
 detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');
%%
% Display the detected stop sign.
figure;
imshow(detectedImg);

