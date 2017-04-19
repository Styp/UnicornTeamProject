for i = 1:24

 string = ['Testbilder/Test',num2str(i),'.jpg'] ;

 image = imread(string);
 %bw= rgb2gray(image);
 %bw = edge(bw, 'Canny',[0.01, 0.5]);
 %bw = personalized_edge_detection(image);
 
 %[centers, radii] = imfindcircles(bw,[20,60]);
 
 %figure
 %imshow(image)
% h = viscircles(centers,radii);
 
%version 1 vs. version 2 


[boxes,~] = detect_warning_sign(image);

%if isempty(boxes) == false
%figure 
%imshow(image)
%plot_bounding_boxes(boxes,200)
%end
end