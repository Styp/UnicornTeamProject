testImg = imread('/opt/dataset/GTSRB/Final_Training/Images/00014/00000_00000.ppm');

grayImg = rgb2gray(testImg);

figure
grayImg
imshow(grayImg)

%%% compression
[TU,TS,TV] = svd(single(grayImg));
SV = diag(TS);
s = size(SV);

rank = s(1);

U_compressed = TU(:, 1:45);
V_compressed = TV(1:45, :);

vector = 1:45

TCS(1) = SV(1);
for k = 2: s(1)
    TCS(k) = TCS(k-1) + SV(k);
end


%% decompressionat
v = 2

% find the rank used for each block
rr = 5;
k = s(1)-1;
while (k >=1) 
        if ( (TCS(k) <= v) & (TCS(k+1) >= v))
                rr = k+1;
                break;
        end;
        k = k-1;
end

  X = TU(:, 1:rr) * TS(1:rr, 1:rr) * TV(:, 1:rr)'
  
  figure
  imshow(uint8(X));
  
  figure
  testicles = uint8(grayImg) - uint8(X);
  imshow(uint8(testicles));
  