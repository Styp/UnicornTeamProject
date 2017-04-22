function [ final_bounding_boxes ] = merge_bounding_boxes( image, boxes_and_weights, sensitivity )
%this function merges the bounding boxes given as the boxes_and_weights
%togehter with the weights given in the last column of the
%boxes_and_weights input. The sensitivity gives when a region of interest
%is attained, i.e. enough bounding boxes with according weights were
%detected in that area
% Then the function draws a bounding box where the other bounding boxes
% overlap

[n,m,~] = size(image);

test_image = zeros(n,m);

[n,~] = size(boxes_and_weights);

for i = 1:n
    
    %defines the area of the bounding box in the image
    index_x= ceil(boxes_and_weights(i,2)) :...
       floor( boxes_and_weights(i,2) + boxes_and_weights(i,4));
  
    index_y=  ceil(boxes_and_weights(i,1)) : ...
        floor(boxes_and_weights(i,1)+boxes_and_weights(i,3));
   %extract the weight
    weight = boxes_and_weights(i,5);
    % and the weight to all pixels contained in the bounding box
 
test_image(index_x,index_y) = test_image(index_x,index_y)+ weight;
      
end
    % test_image now contains weights for all pixels in the picture
    % according to their occurence in different bounding boxes.
    
    % now we extract the bounding boxes with a weight heigher than the
    % input parameter sensitivity
        
  test_image(:,:) = test_image(:,:)>=sensitivity;  
% binary image with 1s determining the region of interest

% now we extract the corresponding boundary boxes

test_image = logical(test_image);  % give a label to each connected component   

segments= regionprops(test_image, 'BoundingBox');
numberOfSegments = size(segments, 1);

final_bounding_boxes = zeros(numberOfSegments,4);
for k = 1:numberOfSegments
final_bounding_boxes(k,:) = segments(k).BoundingBox;
end
end


