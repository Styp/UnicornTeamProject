
function [imgDataset] = getPositiveImageSetBig(basePath)

    gtFilePath = strcat(basePath, '/GT-00014.csv');
    gtFile = readtable(gtFilePath);

    length = size(gtFile);
    i = 1;
    
    signs = [];

    
    for k=1:length(1,1)
            x1 = gtFile{k,4};
            y1 = gtFile{k,5};
            x2 = gtFile{k,6};
            y2 = gtFile{k,7};
            type = gtFile{k,8};

            if (x1 >= 1) && (y1 >= 1) && (x2 >= 1) && (y2 >= 1)
                name = strcat(basePath, '/', gtFile{k,1});
                if(x2-x1 >= 16 && y2-y1 >= 16)
                    signs(i).imageFilename = name;
                    positionOfSign = [x1,y1,x2-x1,y2-y1];
                    signs(i).position = positionOfSign;
                    i = i + 1;
                end

            end
        
    end
  
    resultTable = struct2table(signs);
    imgDataset = resultTable(:, {'imageFilename', 'position'});
    
    
end