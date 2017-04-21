%{
9 = no overtaking (prohibitory)
10 = no overtaking (trucks) (prohibitory)
11 = priority at next intersection (danger)
12 = priority road (other)
13 = give way (other)
14 = stop (other)
15 = no traffic both ways (prohibitory)
16 = no trucks (prohibitory)
17 = no entry (other)
18 = danger (danger)
19 = bend left (danger)
20 = bend right (danger)
21 = bend (danger)
22 = uneven road (danger)
23 = slippery road (danger)
24 = road narrows (danger)
25 = construction (danger)
26 = traffic signal (danger)
27 = pedestrian crossing (danger)
28 = school crossing (danger)
29 = cycles crossing (danger)
30 = snow (danger)
31 = animals (danger)
32 = restriction ends (other)
33 = go right (mandatory)
34 = go left (mandatory)
35 = go straight (mandatory)
36 = go right or straight (mandatory)
37 = go left or straight (mandatory)
38 = keep right (mandatory)
39 = keep left (mandatory)
40 = roundabout (mandatory)
41 = restriction ends (overtaking) (other)
42 = restriction ends (overtaking (trucks)) (other)

%}



function imgDataset = loadImageData(basePath, gtFile)

    length = size(gtFile);
    i = 1;
    signs = [];

    
    for k=1:length(1,1)
            x1 = gtFile{k,2};
            y1 = gtFile{k,3};
            x2 = gtFile{k,4};
            y2 = gtFile{k,5};
            type = gtFile{k,6};

            if (x1 >= 1) && (y1 >= 1) && (x2 >= 1) && (y2 >= 1)
               signs(i).imageFilename = strcat(basePath, '/', gtFile{k,1});
            
               signs(i).position = [x1,y1,x2-x1,y2-y1];
               
               signs(i).type = type;
               
               i = i+1;
            end

    end
  
resultTable = struct2table(signs);
imgDataset = resultTable(:, {'imageFilename', 'position', 'type'});

end
