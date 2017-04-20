function  [bb_all, label, method] = benchmarkImage(rcnn, frame)

    % Read test image
    imgTest = frame;

    % Detect stop signs
    [bboxes, score, label] = detect(rcnn, imgTest, 'MiniBatchSize', 128);

    outputImage = imgTest;
    
    bb_all = zeros(0,4);
    j = 1;
    for i = 1:size(score,1)
        currentScore = score(i);
        idx = i;
        if(currentScore >= 0.9)
            bbox = bboxes(idx, :);
            bb_all(j,1:4) =  bbox;
            annotation = sprintf('%s: (Confidence = %f)', label(idx), currentScore);

            outputImage = insertObjectAnnotation(outputImage, 'rectangle', bbox, annotation);
            j = j+1;
        end
    end
    
    method = ones(size(bb_all,1),1);
    
%     figure(1);
%     imshow(outputImage);
end
