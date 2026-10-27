clear;
clc;
close all;

pkg load image;

img = imread('./einstein.jpg');

if size(img, 3) == 3
    img = rgb2gray(img);
end

[h, w] = size(img);
h = floor(h / 8) * 8;
w = floor(w / 8) * 8;

img = img(1:h, 1:w);

A = double(img) - 128;

N = 8;
T = zeros(N, N);

for k = 0:N-1
    for n = 0:N-1

        if k == 0
            c = sqrt(1/N);
        else
            c = sqrt(2/N);
        end

        T(k+1, n+1) = c * cos(pi * (2*n+1) * k / (2*N));

    end
end

alphas = [1 2 5 10];

figure;

subplot(2, 3, 1);
imshow(img);
title('Original image');

for k = 1:length(alphas)

    alpha = alphas(k);

    encoded = zeros(h, w);
    decoded = zeros(h, w);

    for i = 1:8:h
        for j = 1:8:w
            block = A(i:i+7, j:j+7);
            D = T * block * T';
            Dq = quantization(D, alpha);
            encoded(i:i+7, j:j+7) = Dq;
            Dr = dequantization(Dq, alpha);
            decoded(i:i+7, j:j+7) = T' * Dr * T;
        end
    end

    reconstructed = uint8( ...
        min(max(decoded + 128, 0), 255));

    zero_count = numel(encoded) - nnz(encoded);
    zero_percent = 100 * zero_count / numel(encoded);

    mse = mean((double(img(:)) - ...
                double(reconstructed(:))).^2);

    fprintf('Alpha = %d | Zeros = %.2f%% | MSE = %.2f\n', ...
            alpha, zero_percent, mse);

    subplot(2, 3, k+1);
    imshow(reconstructed);

    title(sprintf('Alpha = %d | Zeros = %.1f%%', ...
                  alpha, zero_percent));

end

sgtitle('JPEG Compression Comparison');

