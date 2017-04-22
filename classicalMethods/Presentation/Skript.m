%examples for color thresholding
test_threshold = imread('color_threshold_1.jpg');

[test_threshold_bw, ~] = personalized_threshold(test_threshold);

f1 = figure;
imshow(test_threshold_bw);
saveas(f1,'color_threshold_1_bw.jpg');

test_threshold = imread('color_threshold_2.jpg');

[test_threshold_bw, ~] = personalized_threshold(test_threshold);

f1 = figure;
imshow(test_threshold_bw);
saveas(f1,'color_threshold_2_bw.jpg');

%% examples for edge detection

test_hough = imread('hough_1.jpg');

[bounding_boxes,~,~] = detect_traffic_sign_hough(test_hough,'warning');
grayImage = rgb2gray(test_hough);
edgeImage = edge(grayImage, 'canny',[0.005, 0.5]);

f1 = figure;
imshow(edge(edgeImage,'canny',[0.05,0.5]));
plot_bounding_boxes(bounding_boxes,1);
saveas(f1,'hough_bw.jpg');

%% 

test_hough = imread('hough_2.png');

[bounding_boxes,~,~] = detect_traffic_sign_hough(test_hough,'stop');
grayImage = rgb2gray(test_hough);
edgeImage = edge(grayImage, 'canny',[0.005, 0.5]);

f1 = figure;
imshow(edge(edgeImage,'canny',[0.05,0.5]));
plot_bounding_boxes(bounding_boxes,1);
saveas(f1,'hough_2_bw.jpg');
