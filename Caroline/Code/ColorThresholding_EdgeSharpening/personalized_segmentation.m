function [ SegmentsMeasurements] = personalized_segmentation( originalImage )
% input is supposed to be a binary image


labeledImage = bwlabel(originalImage, 8);     % Label each area so we can make measurements of it

SegmentsMeasurements = regionprops(labeledImage, originalImage, 'all');



end

