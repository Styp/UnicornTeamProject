image= Test1;


Test_11_1 = imsharpen(image);
Test_11_1 = imsharpen(Test_11_1);
Test_11_1 = imsharpen(Test_11_1);
%histeq:

Test_11_1 = histeq(Test_11_1);
Test_11_1 = rgb2gray(Test_11_1);
Test_11_1 = edge(Test_11_1, 'Canny',[0.01, 0.5]);
imshow(Test_11_1)

figure
Test_11_1 = imfill(Test_11_1,'holes');
imshow(Test_11_1)

figure
Test_11_1 = ordfilt2(Test_11_1,36,ones(6,6));
imshow(Test_11_1)



figure
image = personalized_threshold_2(image);
imshow(image)

figure
image2 = image + Test_11_1;
imshow(image)