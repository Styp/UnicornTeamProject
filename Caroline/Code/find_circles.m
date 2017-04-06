function [ bounding_box , centers , radi ] = find_circles( image , size)
 % This function searches for circles in a picture. 
 % Input values are the image, and a vector of the 
 % It returns a matrix containing the information for the bounding
 % boxes of the circles 
 % rows : different bounding boxes
 % colums : x bottom left, y bottom left, width, height

 
% image processing before searched for circles
bw= rgb2gray(image);
bw = edge(bw, 'Canny',[0.005; 0.5]);

 
 [centers, radi] = imfindcircles(bw,[15,45]); 

 bounding_box=[];
 bounding_box= [bounding_box;
        centers(:,1)-radi, centers(:,2)-radi, 2*radi,2*radi];
  
    
    
end

