function [ bounding_boxes] = detect_signs_2( image )
%this function gets an image as input. Than it computes the bounding boxes
%which border the regions of intrest for three different methods. (color
%thresholding, edge detection and circle detection). 
%Finally the bounding boxes for the area where at least two bounding boxes
%of all methods overlap are returned. 

%first use three different detection methods 
[~,threshold_boxes] = personalized_threshold(image);
[~,edge_boxes] = personalized_edge_detection(image);
[circle_boxes] = find_circles(image,[15,45]);

% create input vector for the merge bounding box input
% all methods with same input 1 sensitivity 2
all_boxes = [threshold_boxes;
    edge_boxes;
    circle_boxes];
[n,~] = size(all_boxes);
all_boxes = [all_boxes, ones(n,1)];

bounding_boxes = merge_bounding_boxes(image, all_boxes,2);


end

