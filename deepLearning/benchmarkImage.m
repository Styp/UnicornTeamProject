function benchmarkImage(rcnn, imgPath)

    % Read test image
    imgTest = imread(imgPath);

    % Detect stop signs
    [bboxes, score, label] = detect(rcnn, imgTest, 'MiniBatchSize', 128)

    outputImage = imgTest;
    
    for i = 1:size(score,1)
        currentScore = score(i);
        idx = i;
        if(currentScore >= 0.9)
  
            bbox = bboxes(idx, :);
            annotation = sprintf('%s: (Confidence = %f)', label(idx), currentScore);

            outputImage = insertObjectAnnotation(outputImage, 'rectangle', bbox, annotation);

        end
    end

    figure(1);
    imshow(outputImage);

end
