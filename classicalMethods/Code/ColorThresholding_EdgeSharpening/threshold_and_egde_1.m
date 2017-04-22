function [ bounding_boxes ] =  threshold_and_egde_1( image )
% this function computes the threshold image for the colors
% (red,blue, yellow) and an image with blurred and strengthend edges
% obtained by the personalized threshold function. 
% We only return the bounding boxes of the areas, where both images
% displayed white. 

% compute threshold image sensible to red,blue and yellow
threshold_image = personalized_threshold(image); 

% compute the image where we detect the edges, widen them and fill the
% holes
edge_image = personalized_edge_detection(image);

% combine two binary image
combined_image = min(threshold_image(:,:,1), edge_image(:,:,1));


bounding_boxes = get_bounding_boxes(combined_image);

end

