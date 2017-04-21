baseDir = '/opt/dataset/FullIJCNN2013';

gtFilePath = strcat(baseDir, '/gt.txt');
gtFile = readtable(gtFilePath);


imgDataset = loadImageData(baseDir, gtFile);
length = size(imgDataset);

for k=1:length(1,1)

    path = imgDataset{k,1};
    currentImage = imread(path{1});
    boundingBox = imgDataset{k,2};
    type = imgDataset{k,3};
    
    [ final_boundingBox, label, method ] = detect_giveway_sign(currentImage);
    
    if(isempty(final_boundingBox) == false)
    outputImage = insertObjectAnnotation(currentImage, 'rectangle', final_boundingBox, 'SUPER DETECTION');

    figure(1);
    imshow(outputImage);
    end
    
    
        
    
end

