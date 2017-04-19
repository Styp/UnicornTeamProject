function [ true ] = detect_shape( image )
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

value = 'false'

% detect circles 
size = size(image);
size = max(size(1,2))
[centers,~] = imfindcircles(image,[0.5*size, 0.25*size]);

if  isempty(centers) == 'false'
     value= true;
     return
end



end

