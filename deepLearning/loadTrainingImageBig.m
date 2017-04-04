
function [trainImage, trainLabel] = loadTrainingImageBig(path)

    % load data
    trainImage = [];
    labelPointer = [];
    j = 1;
    for folder = 1:43
        real_folder = folder - 1; % MATLAB DOESNT SUPPORT 0 - HIGH FIVE!
        currentFolder = pad(num2str(real_folder),5,'left','0');
        folderPath = strcat(path, '/', currentFolder);
        allFilesInFolder = dir(folderPath);
        for i = 1:size(allFilesInFolder,1)
            currentFolder = allFilesInFolder(i);
            if (currentFolder.isdir == 0 && contains(currentFolder.name, '.ppm'))
                name = strcat(folderPath, '/', allFilesInFolder(i).name);
                resizeImage = imread(name);
                outputImage = imresize(resizeImage,[32,32]);
                trainImage(:,:,:,j) = outputImage;
                labelPointer(j) = real_folder;
                j = j+1;
            end
        end 
    end
    
    % parse categorial
    
    trainLabel = categorical(labelPointer');
    
    
end