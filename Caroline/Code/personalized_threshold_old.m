function [ masked_image ] = personalized_threshold_old( I )
%this function thresholds blue, read and yellow
% uses RGB

channel1redMin = 90;
channel1redMax = 255;
% Define thresholds for channel 2 based on histogram settings
channel2redMin = 0.000;
channel2redMax = 70.000;
% Define thresholds for channel 3 based on histogram settings
channel3redMin = 0.000;
channel3redMax = 70.000;


% Define thresholds for yellow channel 1 based on histogram settings
channel1yMin = 188.000;
channel1yMax = 251.000;
% Define thresholds for yellow channel 2 based on histogram settings
channel2yMin = 185.000;
channel2yMax = 244.000;
% Define thresholds for yellow channel 3 based on histogram settings
channel3yMin = 11.000;
channel3yMax = 113.000;

% Define thresholds for blue channel 1 based on histogram settings
channel1bMin = 0.000;
channel1bMax = 113.000;
% Define thresholds for blue channel 2 based on histogram settings
channel2bMin = 0.000;
channel2bMax = 115.000;
% Define thresholds for blue channel 3 based on histogram settings
channel3bMin = 124.000;
channel3bMax = 255.000;



% Create mask based on chosen histogram thresholds
 masked_image = (I(:,:,1) >= channel1redMin ) & (I(:,:,1) <= channel1redMax) & ...
    (I(:,:,2) >= channel2redMin ) & (I(:,:,2) <= channel2redMax) & ...
    (I(:,:,3) >= channel3redMin ) & (I(:,:,3) <= channel3redMax) ...
    |...
    (I(:,:,1) >= channel1yMin ) & (I(:,:,1) <= channel1yMax) & ...
    (I(:,:,2) >= channel2yMin ) & (I(:,:,2) <= channel2yMax) & ...
    (I(:,:,3) >= channel3yMin ) & (I(:,:,3) <= channel3yMax)...
    |...
    (I(:,:,1) >= channel1bMin ) & (I(:,:,1) <= channel1bMax) & ...
    (I(:,:,2) >= channel2bMin ) & (I(:,:,2) <= channel2bMax) & ...
    (I(:,:,3) >= channel3bMin ) & (I(:,:,3) <= channel3bMax);
    
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

masked_image = imdilate(masked_image, [se90 se0]);
end

