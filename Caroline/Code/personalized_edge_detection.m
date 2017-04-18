function [ image,bounding_boxes ] = personalized_edge_detection ( original_image)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
image= original_image;

% as edge detection works with graz images we transform the image to gray
image = rgb2gray(image);

%blurring the picture to reduce noise, we use the mean filter on a 5x5 
%neighborhood.
image = medfilt2(image, [5,5]);
image = medfilt2(image, [5,5]);

%use histogram equailzation and gamma transform to obtain a higher contrast
image = histeq(image);
image = im2double(image).^0.8;
image = histeq(image);

% sharpening for better edge detection 
image = imsharpen(image);
image = imsharpen(image);

%edge detection
image = edge(image, 'Canny',[0.005, 0.5]);

%fill holes for better potential area
image = imfill(image,'holes');

%blur the edges 
image = ordfilt2(image,25,ones(5,5));

%fill holes for better potential area
image = imfill(image,'holes');

%blur the edges 
image = ordfilt2(image,25,ones(5,5));

%fill holes for better potential area
image = imfill(image,'holes');


bounding_boxes = get_bounding_boxes(image);

end

