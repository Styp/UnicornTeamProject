function [ bounding_box] = find_circles( image, radius)
 % This function searches for circles in a picture. 
 % Input values are the image, and a 1x2 vector of the estimated upper and
 % lower boundary of the radius (upper boundary should be less than three
 % times lower boundray)
 % It returns a matrix containing the information for the bounding
 % boxes of the circles 
 % rows : different bounding boxes
 % colums : x bottom left, y bottom left, width, height

 
% image processing before we search for circles
bw= rgb2gray(image);
bw = edge(bw, 'Canny',[0.005; 0.5]);

% detection of circles 
[centers, radi] = imfindcircles(bw,radius); 


bounding_box=[];

%if we found circles we compute the boundary boxes
 if isempty(centers) == false
 bounding_box= [bounding_box;
        centers(:,1)-radi, centers(:,2)-radi, 2*radi,2*radi];
 end 
    
    
end

