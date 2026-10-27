
clear;
clc;
close all;

pkg load image;

img = imread('./einstein.jpg');

if size(img, 3) == 3
    img = rgb2gray(img);
end

img = double(img);

radii = [2 5 10 20];

figure;

subplot(2, 3, 1);
imshow(uint8(img));
title('Original image');

for k = 1:length(radii)

    rho = radii(k);

    [X, Y] = meshgrid(-rho:rho, -rho:rho);

    K = double(X.^2 + Y.^2 <= rho^2);

    K = K / sum(K(:));

    blurred = conv2(img, K, 'same');

    subplot(2, 3, k+1);
    imshow(uint8(min(max(blurred, 0), 255)));

    title(sprintf('Blur radius = %d', rho));

end

