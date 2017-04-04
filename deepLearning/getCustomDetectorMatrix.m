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



function imgDataset = getCustomDetectorMatrix(basePath, gtFile)

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
            
               positionOfSign = [x1,y1,x2-x1,y2-y1];

               signs(i).speed20 = [];
               signs(i).speed30 = [];
               signs(i).speed50 = [];
               signs(i).speed60 = [];
               signs(i).speed70 = [];
               signs(i).speed80 = [];
               signs(i).restriction_ends = [];
               signs(i).speed100 = [];
               signs(i).speed120 = [];
               signs(i).no_overtaking = [];
               signs(i).no_overtaking = [];
               signs(i).priority_at_next_intersection = [];
               signs(i).priority_road = [];
               signs(i).give_way = [];
               signs(i).stop = [];
               signs(i).no_traffic = [];
               signs(i).no_trucks = [];
               signs(i).no_entry = [];
               signs(i).danger = [];
               signs(i).bend_left = [];
               signs(i).bend_right = [];
               signs(i).bend = [];
               signs(i).uneven_road = [];
               signs(i).slippery_road = [];
               signs(i).road_narrows = [];
               signs(i).construction = [];
               signs(i).traffic_signal = [];
               signs(i).pedesterian_crossing = [];
               signs(i).school_crossing = [];
               signs(i).cycles_crossing = [];
               signs(i).snow = [];
               signs(i).animals = [];
               signs(i).restriction_ends = [];
               signs(i).go_right = [];
               signs(i).go_left = [];
               signs(i).go_straight = [];
               signs(i).go_right_or_straight = [];
               signs(i).go_left_or_straight = [];
               signs(i).keep_right = [];
               signs(i).keep_left = [];
               signs(i).roundabout = [];
               signs(i).restriction_ends = [];
               signs(i).restriction_ends = [];
               signs(i).unknown = [];
                              
               if(type == 0)
                   signs(i).speed20 = positionOfSign;
               elseif(type == 1)
                   signs(i).speed30 = positionOfSign;
               elseif(type == 2)
                   signs(i).speed50 = positionOfSign;
               elseif(type == 3)
                   signs(i).speed60 = positionOfSign;
               elseif(type == 4)
                   signs(i).speed70 = positionOfSign;
               elseif(type == 5)
                   signs(i).speed80 = positionOfSign;
               elseif(type == 6)
                   signs(i).restriction_ends = positionOfSign;
               elseif(type == 7)
                   signs(i).speed100 = positionOfSign;
               elseif(type == 8)
                   signs(i).speed120 = positionOfSign;
               elseif(type == 9)
                   signs(i).no_overtaking = positionOfSign;
               elseif(type == 10)
                   signs(i).no_overtaking = positionOfSign;
               elseif(type == 11)
                   signs(i).priority_at_next_intersection = positionOfSign;
               elseif(type == 12)
                   signs(i).priority_road = positionOfSign;
               elseif(type == 13)
                   signs(i).give_way = positionOfSign;
               elseif(type == 14)
                   signs(i).stop = positionOfSign;
               elseif(type == 15)
                   signs(i).no_traffic = positionOfSign;
               elseif(type == 16)
                   signs(i).no_trucks = positionOfSign;
               elseif(type == 17)
                   signs(i).no_entry = positionOfSign;
               elseif(type == 18)
                   signs(i).danger = positionOfSign;
               elseif(type == 19)
                   signs(i).bend_left = positionOfSign;
               elseif(type == 20)
                   signs(i).bend_right = positionOfSign;
               elseif(type == 21)
                   signs(i).bend = positionOfSign;
               elseif(type == 22)
                   signs(i).uneven_road = positionOfSign;
               elseif(type == 23)
                   signs(i).slippery_road = positionOfSign;
               elseif(type == 24)
                   signs(i).road_narrows = positionOfSign;
               elseif(type == 25)
                   signs(i).construction = positionOfSign;
               elseif(type == 26)
                   signs(i).traffic_signal = positionOfSign;
               elseif(type == 27)
                   signs(i).pedesterian_crossing = positionOfSign;
               elseif(type == 28)
                   signs(i).school_crossing = positionOfSign;
               elseif(type == 29)
                   signs(i).cycles_crossing = positionOfSign;
               elseif(type == 30)
                   signs(i).snow = positionOfSign;
               elseif(type == 31)
                   signs(i).animals = positionOfSign;
               elseif(type == 32)
                   signs(i).restriction_ends = positionOfSign;
               elseif(type == 33)
                   signs(i).go_right = positionOfSign;
               elseif(type == 34)
                   signs(i).go_left = positionOfSign;
               elseif(type == 35)
                   signs(i).go_straight = positionOfSign;
               elseif(type == 36)
                   signs(i).go_right_or_straight = positionOfSign;
               elseif(type == 37)
                   signs(i).go_left_or_straight = positionOfSign;
               elseif(type == 38)
                   signs(i).keep_right = positionOfSign;
               elseif(type == 39)
                   signs(i).keep_left = positionOfSign;
               elseif(type == 40)
                   signs(i).roundabout = positionOfSign;
               elseif(type == 41)
                   signs(i).restriction_ends = positionOfSign;
               elseif(type == 42)
                   signs(i).restriction_ends = positionOfSign; 
               else
                   signs(i).unknown = positionOfSign;
               end
                   
               i = i+1;
            end

    end
  
resultTable = struct2table(signs);
imgDataset = resultTable(:, {
    'imageFilename', 'speed20', 'speed30', 'speed50', 'speed60', 'speed70', 'speed80', 'restriction_ends', 'speed100', 'speed120', 'no_overtaking', 'no_overtaking', 'priority_at_next_intersection', 'priority_road', 'give_way', 'stop', 'no_traffic', 'no_trucks', 'no_entry', 'danger', 'bend_left', 'bend_right', 'bend', 'uneven_road', 'slippery_road', 'road_narrows', 'construction', 'traffic_signal', 'pedesterian_crossing', 'school_crossing', 'cycles_crossing', 'snow', 'animals', 'go_right', 'go_left', 'go_straight', 'go_right_or_straight', 'go_left_or_straight', 'keep_right', 'keep_left', 'roundabout', 'unknown'               
    });

end
