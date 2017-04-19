function [ bounding_boxes ] = detect_signs( image )
% this function computes the area in an image where we dectect colors
% associated with a traffic sign (red,yellow,blue) AND filled edges. We
% than return the bounding boxes of the so computed regions of interest

% compute threshold image sensible to red,blue and yellow
threshold_image = personalized_threshold(image); 

% compute the image where we detect the edges, widen them and fill the
% holes
edge_image = personalized_edge_detection(image);

% combine two binary image
combined_image = min(threshold_image(:,:,1), edge_image(:,:,1));


bounding_boxes = get_bounding_boxes(combined_image);

end

