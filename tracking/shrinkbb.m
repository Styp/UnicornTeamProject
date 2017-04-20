function bb_s = shrinkbb(bb,a)
    bb_s = bb;
    bb_s(:,1) =  bb(:,1) + 0.5*(1-a)*bb(:,3);
    bb_s(:,2) =  bb(:,2) + 0.5*(1-a)*bb(:,4);
    bb_s(:,3) =  a*bb(:,3);
    bb_s(:,4) =  a*bb(:,4);
end