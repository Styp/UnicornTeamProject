for i = 1:10

 string = ['Testbilder/Test',num2str(i),'.jpg'] ;

 image = imread(string);
 bw= rgb2gray(image);
 bw = edge(bw, 'Canny',[0.01, 0.5]);
 %bw = personalized_edge_detection(image);
 
 [centers, radii] = imfindcircles(bw,[20,60]);
 
 figure
 imshow(image)
 h = viscircles(centers,radii);
 
 
 %detect_signs(image)
end