% #####################################################################
% ##############  initialize_tracks  ##################################
% #####################################################################
% This script is used by track_bb.m to initialize the tracker for each 
% bounding box in bb_all. Furthermore it plots the initial bounding boxes 
% into the current frame (depending on the values in method).

%% loop through all boundingboxes
N = size(bb_all,1);
for i = 1:N
    roi = 'ROI';
    
    %% Make sure that bbox is fully inside frame.
     bb_points = bbox2points(bb_all(i,:));      % convert to points
     bb_points(1,1) = min(size(frame,2), max(1, bb_points(1,1)));
     bb_points(2,1) = min(size(frame,2), max(1, bb_points(2,1)));
     bb_points(3,1) = min(size(frame,2), max(1, bb_points(3,1)));
     bb_points(4,1) = min(size(frame,2), max(1, bb_points(4,1)));
     bb_points(1,2) = min(size(frame,1), max(1, bb_points(1,2)));
     bb_points(2,2) = min(size(frame,1), max(1, bb_points(2,2)));
     bb_points(3,2) = min(size(frame,1), max(1, bb_points(3,2)));
     bb_points(4,2) = min(size(frame,1), max(1, bb_points(4,2)));
     bb_all(i,:) = points2bb(bb_points);        % convert back to bbox
    %%
     
    % Get feature points inside i-th shrinked bounding box. 
    % If no points are returned try again with full bounding box.
    % If no points are returned try again with bigger bounding box.
    eval([sprintf('points%d',i) '= detectMinEigenFeatures(rgb2gray(frame),roi,shrinkbb(bb_all(i,:),0.6));']);
    if isempty(eval(sprintf('points%d',i)))
        eval([sprintf('points%d',i) '= detectMinEigenFeatures(rgb2gray(frame),roi,shrinkbb(bb_all(i,:),1));']);
    end
    if isempty(eval(sprintf('points%d',i)))
        eval([sprintf('points%d',i) '= detectMinEigenFeatures(rgb2gray(frame),roi,shrinkbb(bb_all(i,:),1.2));']);
    end
    
    % Save Coordinates of feature points for i-th bounding box.
    eval(sprintf('xyPoints%d = points%d.Location;',i,i));
    numPts_all(i,1) = eval(sprintf('size(xyPoints%d,1)',i));
    
    % Construct i-th tracker.
    tracker = vision.PointTracker('MaxBidirectionalError',1);
    eval(sprintf('tracker%d = tracker;',i));
    
    % Save points for bbox transformation of first tracking iteration
    eval(sprintf('oldPoints%d = xyPoints%d;',i,i))
    
    % Convert bbox
    eval(sprintf('bboxPoints%d = bbox2points(bb_all(i, :));',i));
    eval(sprintf('bboxPolygon%d = reshape(transpose(bboxPoints%d), 1, []);',i,i));

    % insert feature points in current frame
    %frame = insertMarker(frame, eval(sprintf('points%d.Location',i)), '+', 'Color', 'white');
    
    %% Plot bounding boxes into frame (depending on method.
    if method(i,1) == 1         % deep learning
        frame = insertShape(frame, 'rectangle', bb_all(i, :), 'LineWidth', 3, 'Color', 'yellow');
        frame = insertObjectAnnotation(frame, 'rectangle', bb_all(i, :), sprintf('%s',label(i)),'FontSize',20, 'Color', 'yellow');
    elseif method(i,1) == 2     % circle detection
        frame = insertShape(frame, 'circle', [bb_all(i, 1)+0.5*bb_all(i, 3), bb_all(i, 2)+0.5*bb_all(i, 4), 0.5*bb_all(i, 3)], 'LineWidth', 3, 'Color', 'white');
        %frame = insertObjectAnnotation(frame, 'rectangle', bb_all(i, :), sprintf('%s',label(i)),'FontSize',10, 'Color', 'yellow');
    elseif method(i,1) == 3     % triangle down detection
        frame = insertShape(frame, 'rectangle', bb_all(i, :), 'LineWidth', 3, 'Color', 'white');
        frame = insertObjectAnnotation(frame, 'rectangle', bb_all(i, :), sprintf('%s',label(i)), 'FontSize', 20, 'Color', 'white');
    elseif method(i,1) == 12     % deep learning and circle detection merged
        circle_bb = bb_all(i, :);
        circle_bb = [circle_bb(1)+0.5*circle_bb(3), circle_bb(2)+0.5*circle_bb(4), 0.5*circle_bb(3)];
        frame = insertShape(frame, 'rectangle', bb_all(i, :), 'LineWidth', 3, 'Color', 'magenta');
        frame = insertObjectAnnotation(frame, 'rectangle', bb_all(i, :), sprintf('%s',label(i)), 'FontSize', 20, 'Color', 'magenta');
        frame = insertShape(frame, 'circle', circle_bb, 'LineWidth', 3, 'Color', 'magenta');  
    end
    %%
    
    %% initialize i-th tracker 
    if ~isempty(eval(sprintf('xyPoints%d',i)))
        initialize(eval(sprintf('tracker%d',i)),eval(sprintf('xyPoints%d',i)),frame);
    else
        initialize(eval(sprintf('tracker%d',i)), [bb_all(i,1)+0.5*bb_all(i,3), bb_all(i,2)+0.5*bb_all(i,4)],frame);
    end
end



