clear;
clc;
warning off;

%% Parameters
start_frame_nr = 750;                   % frame to start at
filename_input = 'MVI_1214.MP4';        % input video
filename_output = 'myFile14.avi';       % output video
N = 20;                                 % one detection step after N-1 tracking steps
a_resize = 0.5;                           % resize factor for input video frames
%%

% read input video file
videoFileReader = VideoReader(filename_input);

% create output video file
videoFileWriter = vision.VideoFileWriter(filename_output,'FrameRate',videoFileReader.FrameRate);

% read frame
frame = imresize(read(videoFileReader,start_frame_nr),a_resize);

% load net 
load('signDetector.mat');

% run initial sign detection on first frame
[bb_all_1, label_1, method_1] = benchmarkImage(rcnn, frame);
[bb_all_2, label_2, method_2] = find_circles(frame,[15,45]);
bb_all = [bb_all_1; bb_all_2];
label = [label_1; label_2];
method = [method_1; method_2];
%bb_all = [bb_all ; shrinkbb(feature_matching_all(frame),shrink_factor)];

% initialize tracks
initialize_tracks;

% loop through input video
j = start_frame_nr+1;
while videoFileReader.CurrentTime < videoFileReader.Duration
    
      % get next frame  
      frame = imresize(read(videoFileReader,j),a_resize);
      
      
      if mod(j,N) == 0 
            %% redetection
            
            % run sign detection
            [bb_all_1, label_1, method_1] = benchmarkImage(rcnn, frame);
            [bb_all_2, label_2, method_2] = find_circles(frame,[15,45]);
            bb_all = [bb_all_1; bb_all_2];
            label = [label_1; label_2]
            method = [method_1; method_2];
            %bb_fm = shrinkbb(feature_matching_all(frame),shrink_factor);
            
            % re-initialize tracks
            initialize_tracks;
            
            % plot red dot
            frame = insertShape(frame, 'FilledCircle', [50,1190,30], 'LineWidth', 3, 'Color', 'r');
            
            %display current time
            videoFileReader.CurrentTime
      else                  
            %% tracking mode
            for i=1:bb_n
                % get tracked points
                [points, validity] = step(eval(sprintf('tracker%d',i)),frame);
                oldPoints = eval(sprintf('oldPoints%d;',i));
                bboxPoints = eval(sprintf('bboxPoints%d;',i));
                numPts = size(points(validity, :), 1);
        
                if numPts >= 3
                    % estimate geometric transformation of bounding box
                    [xform, ~, ~] = estimateGeometricTransform(...
                        oldPoints(validity, :), points(validity, :), 'similarity', 'MaxDistance', 4);
                    
                    % apply the transformation to the bounding box
                    bboxPoints = transformPointsForward(xform, bboxPoints);
    
                    % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
                    % format required by insertShape.
                    bboxPolygon = reshape(bboxPoints', 1, []);
                    
                    % save points and bounding box for next iteration
                    eval(sprintf('bboxPoints%d = bboxPoints;',i));
                    eval(sprintf('bboxPolygon%d = bboxPolygon;',i));
                    eval(sprintf('oldPoints%d = points;',i));
            
                    % insert bounding box and tracked points in current frame
                    frame = insertMarker(frame, points(validity, :), '+', 'Color', 'white');
                    %frame = insertShape(frame, 'Polygon', eval(sprintf('bboxPolygon%d',i)), 'LineWidth', 5);
                    if method(i,1) == 1
                        frame = insertShape(frame, 'rectangle', points2bb(bboxPoints), 'LineWidth', 3);
                        frame = insertObjectAnnotation(frame, 'rectangle', points2bb(bboxPoints), sprintf('%s',label(i)),'FontSize',10);
                    elseif method(i,1) == 2
                        frame = insertShape(frame, 'rectangle', points2bb(bboxPoints), 'LineWidth', 3, 'Color', 'white');
                        frame = insertObjectAnnotation(frame, 'rectangle', points2bb(bboxPoints), sprintf('%s',label(i)),'FontSize',10, 'Color', 'white');
                    end
                end
            end
      end
      
      % save modified frame in output video
      step(videoFileWriter,frame);
      
      j = j+1;
end

% release output video
release(videoFileWriter);