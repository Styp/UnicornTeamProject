function [ detected_image ] = detect_signs( image )


threshold_image = personalized_threshold_2(image);
%imshow(threshold_image)
edge_image = personalized_edge_detection(image);
%figure
%imshow(edge_image)

combined_image = min(threshold_image(:,:,1), edge_image(:,:,1));

%figure 
%imshow(combined_image)
SegmentsMeasurements = personalized_segmentation(combined_image);


numberOfSegments = size(SegmentsMeasurements, 1);

figure
hold on
imshow(image)


for k = 1 : numberOfSegments           % Loop through all segments.
		% Find the bounding box of each blob.
		thisSegmentsBoundingBox = SegmentsMeasurements(k).BoundingBox;  % Get list of pixels in current blob.
		% Extract out this coin into it's own image.
		subImage = imcrop(image, thisSegmentsBoundingBox);
        
        test = SegmentsMeasurements(k).BoundingBox(3) * SegmentsMeasurements(k).BoundingBox(4) ;
        if test> 150
            rectangle('Position',SegmentsMeasurements(k).BoundingBox,'EdgeColor','r', 'LineWidth', 2)
        end
        
hold off
end







end

