
%% loop through all boundingboxes
bb_n = size(bb_all,1);
for i = 1:bb_n
    roi = 'ROI';
    
    % get feature points inside i-th bounding box
    eval([sprintf('points%d',i) '= detectMinEigenFeatures(rgb2gray(frame),roi,shrinkbb(bb_all(i,:),0.6));']);
    if isempty(eval(sprintf('points%d',i)))
        eval([sprintf('points%d',i) '= detectMinEigenFeatures(rgb2gray(frame),roi,shrinkbb(bb_all(i,:),1));']);
    end
    eval(sprintf('xyPoints%d = points%d.Location;',i,i));
    
    % construct i-th tracker
    tracker = vision.PointTracker('MaxBidirectionalError',1);
    eval(sprintf('tracker%d = tracker;',i));
    
    % save points for bbox transformation of first tracking iteration
    eval(sprintf('oldPoints%d = xyPoints%d;',i,i))
    
    % convert bbox
    eval(sprintf('bboxPoints%d = bbox2points(bb_all(i, :));',i));
    eval(sprintf('bboxPolygon%d = reshape(transpose(bboxPoints%d), 1, []);',i,i));

    % insert bounding box and feature points in current frame
    frame = insertMarker(frame, eval(sprintf('points%d.Location',i)), '+', 'Color', 'white');
    
    if method(i,1) == 1
        frame = insertShape(frame, 'rectangle', bb_all(i, :), 'LineWidth', 3);
        frame = insertObjectAnnotation(frame, 'rectangle', bb_all(i, :), sprintf('%s',label(i)),'FontSize',10);
    elseif method(i,1) == 2
        frame = insertShape(frame, 'rectangle', bb_all(i, :), 'LineWidth', 3, 'Color', 'white');
        frame = insertObjectAnnotation(frame, 'rectangle', bb_all(i, :), sprintf('%s',label(i)),'FontSize',10, 'Color', 'white');
    end
    
    % initialize i-th tracker 
    if ~isempty(eval(sprintf('xyPoints%d',i)))
        initialize(eval(sprintf('tracker%d',i)),eval(sprintf('xyPoints%d',i)),frame);
    else
        initialize(eval(sprintf('tracker%d',i)), [bb_all(i,1)+0.5*bb_all(i,3), bb_all(i,2)+0.5*bb_all(i,4)],frame);
    end
end



