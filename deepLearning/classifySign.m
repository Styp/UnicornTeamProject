img = imread('Data/04/image.000139.jp2');
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