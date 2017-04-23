function y = bb2points(bb)
    y = [bb(1) bb(2);
        bb(1)+bb(3) bb(2);
        bb(1)+bb(3) bb(2)+bb(4);
        bb(1) bb(2)+bb(4);
        bb(1) bb(2)];
end