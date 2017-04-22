function [ ] = plot_bounding_boxes( bounding_boxes, sensitivity_area )
% this function receives a matrix with the bounding_boxes that should be
% plotted. The colums are determined by the upper left coordinate of the
% bounding box, first the x coordinate than y, the third column specifies
% the x width of the bounding box the fourth column the y width of the
% picture. 
% we assume that the image is already opened as a figure
% the sensitivity_area determines the area a bounding box must at least
% cover to be plotted.

[number,~]  = size(bounding_boxes); % number of bounding boxes

hold on
for k = 1 : number          % Loop through all bounding boxes
		
        test = bounding_boxes(k,3) * bounding_boxes(k,4) ;
        if test> sensitivity_area
            rectangle('Position',bounding_boxes(k,:),'EdgeColor','r', 'LineWidth', 2)
        end
        
hold off


end

