clear();
clc();

baseDir = '/opt/dataset/FullIJCNN2013'
baseDirGTSRB = '/opt/dataset/GTSRB/Final_Training/Images/00014'
baseDirBackgroundImage = 'backgroundData/'

negativeFolder = baseDirBackgroundImage;

%%
% Create an |imageDatastore| object containing negative images.
negativeImages = imageDatastore(negativeFolder);

%%
% Load positive instance
positiveImages = getPositiveImageSet(baseDir);

positiveImages2 = getPositiveImageSetBig(baseDirGTSRB);

allPositiveImages = vertcat(positiveImages, positiveImages2);




%%
% Train a cascade object detector called 'stopSignDetector.xml'
% using HOG features.
% NOTE: The command can take several minutes to run.
trainCascadeObjectDetector('signDetector.xml',allPositiveImages, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5,'TruePositiveRate',0.8);
%%
% Use the newly trained classifier to detect a stop sign in an image.
detector = vision.CascadeObjectDetector('signDetector.xml');

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