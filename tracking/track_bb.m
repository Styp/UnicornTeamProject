% #########################################################################
% #####################  track_bb  ########################################
% #########################################################################
%
% This script loads a input video and applies traffic sign detection as
% well as tracking to it. The resulting bounding boxes are ploted into the
% frame and an output video of the manipulated frames is saved. 

% Clear console and workspace and turn of warnings
clc;
warning off;
clear;

%% Parameters
start_frame_nr = 755;                   % frame to start at
filename_input = 'MVI_1214.MP4';        % input video
filename_output = 'myFile23.avi';       % output video
N_redetect = 20;                        % one detection step after N-1 tracking steps
a_resize = 1;                           % resize factor for input video frames
%%

% Read input video file.
videoFileReader = VideoReader(filename_input);

% Create output video file.
videoFileWriter = vision.VideoFileWriter(filename_output,'FrameRate',videoFileReader.FrameRate);

% Read frame.
frame = imresize(read(videoFileReader,start_frame_nr),a_resize);

% Load CNN.
load('signDetector.mat');

disp('detecting... (initial)');

% Execute sign detection methods
[bb_all_1, label_1, method_1] = benchmarkImage(rcnn, frame);
[bb_all_2, label_2, method_2] = find_circles(frame,[15,45]);
[bb_all_3, label_3, method_3] = detect_traffic_sign_hough (frame, 'giveway' );
            
% Bring together results of all methods
bb_all = [bb_all_1; bb_all_2; bb_all_3];
label = [label_1; label_2; label_3];
method = [method_1; method_2; method_3];
label_disp1 = label;        % for displaying information
method_disp1 = method;      % for displaying information
            
% First Merge run: Merging CNN and Hough boxes
[method, label] = merge_dc(bb_all, method, label);
label_disp2 = label;        % for displaying information
method_disp2 = method;      % for displaying information

disp('frame:');
disp(start_frame_nr);
disp('time:');
disp(videoFileReader.CurrentTime);
disp('labels:');
disp([label_disp1, label_disp2]);
disp('methods:');
disp([method_disp1, method_disp2]);  
disp('##########################################');


% Initialize tracks.
numPts_all = zeros(size(bb_all,1),1);
initialize_tracks;


%% Loop through input video
j = start_frame_nr+1;
while videoFileReader.CurrentTime < videoFileReader.Duration
    
      % Get next frame  
      frame = imresize(read(videoFileReader,j),a_resize);
      
      
      if mod(j,N_redetect) == 0
            %% #########  Redetection  #####################
            
            disp('detecting...');
            
            % Go through tracked bboxes and save "solid" ones (method = 12
            % or 13).
            bb_keep = zeros(0,4);
            label_keep = categorical();
            method_keep = zeros(0,1);
            for i=1:N
                if method(i,1) == 12 && numPts_all(i,1) >= 3
                    bb_keep = [bb_keep; bb_all(i,:)];
                    label_keep = [label_keep; label(i,1)];
                    method_keep = [method_keep; 21];
                elseif method(i,1) == 13 && numPts_all(i,1) >= 3
                    bb_keep = [bb_keep; bb_all(i,:)];
                    label_keep = [label_keep; label(i,1)];
                    method_keep = [method_keep; 31];
                end
            end
            
            % Run sign detection methods.
            [bb_all_1, label_1, method_1] = benchmarkImage(rcnn, frame);
            [bb_all_2, label_2, method_2] = find_circles(frame,[15,45]);
            [bb_all_3, label_3, method_3] = detect_traffic_sign_hough (frame, 'giveway' );
              
            disp('##########################################');
            disp('time:');
            disp(videoFileReader.CurrentTime);
            disp('frame:');
            disp(j);
            
            % Bring together detected bboxes from all methods
            bb_all = [bb_all_1; bb_all_2; bb_all_3];
            label = [label_1; label_2; label_3];
            method = [method_1; method_2; method_3];
            label_disp1 = label;        % for displaying information
            method_disp1 = method;      % for displaying information
            
            % First Merge run: Merging CNN and Hough boxes
            [method, label] = merge_dc(bb_all, method, label);
            label_disp2 = label;        % for displaying information
            method_disp2 = method;      % for displaying information
            
            % Bring together detected bboxes and tracked "solid" ones. 
            bb_all = [bb_all; bb_keep];
            label = [label; label_keep];
            method = [method; method_keep];
            
            % Second Merge run: Merging detected bboxes with tracked
            % "solod" ones
            [method, label] = merge_dc(bb_all, method, label);
            label_disp3 = label;        % for displaying information
            method_disp3 = method;      % for displaying information
            
            % for displaying information
            disp('labels:');
            disp(label_disp1);
            disp(label_disp2);
            disp(label_disp3);
            disp('methods:');
            disp(method_disp1);
            disp(method_disp2);
            disp(method_disp3);
            
            % Re-initialize tracks.
            numPts_all = zeros(size(bb_all,1),1);
            initialize_tracks;

            % For displaying information
            disp('##########################################');
            disp('tracking...');
      else                  
            %% ###############  Tracking mode  ############################
            for i=1:N
                % Get tracked points.
                [points, validity] = step(eval(sprintf('tracker%d',i)),frame);
                oldPoints = eval(sprintf('oldPoints%d;',i));
                bboxPoints = eval(sprintf('bboxPoints%d;',i));
                numPts = size(points(validity, :), 1);
                numPts_all(i,1) = numPts;
        
                if numPts >= 2
                    % Estimate geometric transformation of bounding box
                    [xform, ~, ~] = estimateGeometricTransform(...
                        oldPoints(validity, :), points(validity, :), 'similarity', 'MaxDistance', 4);
                    
                    % Apply the transformation to the bounding box.
                    bboxPoints = transformPointsForward(xform, bboxPoints);
    
                    % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
                    % format required by insertShape.
                    bboxPolygon = reshape(bboxPoints', 1, []);
                    
                    % Save points and bounding box for next iteration.
                    eval(sprintf('bboxPoints%d = bboxPoints;',i));
                    eval(sprintf('bboxPolygon%d = bboxPolygon;',i));
                    eval(sprintf('oldPoints%d = points;',i));
                    
                    bb_all(i,:) = points2bb(bboxPoints);
            
                    % Insert tracked points in current frame.
                    %frame = insertMarker(frame, points(validity, :), '+', 'Color', 'white');
                    
                    
                    %% Plot bounding boxes into frame (depending on method.
                    if method(i,1) == 1         % deep learning
                        frame = insertShape(frame, 'rectangle', points2bb(bboxPoints), 'LineWidth', 3, 'Color', 'yellow');
                        frame = insertObjectAnnotation(frame, 'rectangle', points2bb(bboxPoints), sprintf('%s',label(i)), 'FontSize', 20, 'Color', 'yellow');
                    
                    elseif method(i,1) == 2     % circle detection   
                        circle_bb = points2bb(bboxPoints);
                        circle_bb = [circle_bb(1)+0.5*circle_bb(3), circle_bb(2)+0.5*circle_bb(4), 0.5*circle_bb(3)];
                        frame = insertShape(frame, 'circle', circle_bb, 'LineWidth', 3, 'Color', 'white');
                    
                    elseif method(i,1) == 3     % triangle down detection
                        frame = insertShape(frame, 'rectangle', points2bb(bboxPoints), 'LineWidth', 3, 'Color', 'white');
                        frame = insertObjectAnnotation(frame, 'rectangle', points2bb(bboxPoints), sprintf('%s',label(i)), 'FontSize', 20, 'Color', 'white');
                    
                    elseif method(i,1) == 12 || method(i,1) == 21 || method(i,1) == 13 || method(i,1) == 31    % deep learning and circle detection merged
                        circle_bb = points2bb(bboxPoints);
                        circle_bb = [circle_bb(1)+0.5*circle_bb(3), circle_bb(2)+0.5*circle_bb(4), 0.5*circle_bb(3)];
                        frame = insertShape(frame, 'rectangle', points2bb(bboxPoints), 'LineWidth', 3, 'Color', 'magenta');
                        frame = insertObjectAnnotation(frame, 'rectangle', points2bb(bboxPoints), sprintf('%s',label(i)), 'FontSize', 20, 'Color', 'magenta');
                        if method(i,1) == 12 || method(i,1) == 21
                            frame = insertShape(frame, 'circle', circle_bb, 'LineWidth', 3, 'Color', 'magenta');
                        end
                    end                    
                end
            end
      end
      
      % Save modified frame in output video.
      step(videoFileWriter,frame);
      
      % Increase loop index.
      j = j+1;
end

% Release output video.
release(videoFileWriter);