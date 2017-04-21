function [ bounding_boxes] = get_bounding_boxes( binary_image )
% this function receives a binary image and returns the bounding boxes for
% the connected components in the picture with connectivity greater eight


logic_image = logical(binary_image);    

SegmentsMeasurements = regionprops(logic_image, binary_image, 'BoundingBox');
m = length(SegmentsMeasurements);

%transform the bounding boxes contained in a structure to an array
bounding_boxes = zeros(m,4);

for i =1:m
bounding_boxes(i,:) = SegmentsMeasurements(i).BoundingBox;

end
end

