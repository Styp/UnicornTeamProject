function bb = points2bb(P)
    x0 = min(P(:,1));
    y0 = min(P(:,2));
    dx = max(P(:,1)) - x0;
    dy = max(P(:,2)) - y0;
    bb = [x0, y0, dx, dy];
    
end