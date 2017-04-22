function gradientMap = gradientDirection(image)
% Retuns a map with the same size as the image where the pixel values
% indicates the direction of the edge gradients.
sobelFilterX = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
sobelFilterY = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
% Finding the derivatives in the x- and y-direction.
Dx = imfilter(double(image), sobelFilterX, 'same');
Dy = imfilter(double(image), sobelFilterY, 'same');
% Finding the angle of the gradient based on the derivatives in the
% x- and % y-direction. Some trickery with modulo and pi.
gradientMap = mod(atan2(Dy, Dx) + pi(), pi());
end