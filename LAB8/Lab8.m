%% Q1
clear all;
close all;
clc;
addpath('E:\6th Semester\MISP Lab\MyLab\LAB8\Lab 8_data\S2_Q1_utils');
img = imread("E:\6th Semester\MISP Lab\MyLab\LAB8\Lab 8_data\S2_Q1_utils\t2.jpg");
first_slice = double(img(:,:,1));
% Add Gaussian noise to center 4x4 region (not entire image)
[M, N] = size(first_slice);
noise_block = sqrt(15) * randn(4, 4);

r0 = floor((M-4)/2) + 1;
c0 = floor((N-4)/2) + 1;


noisy_first_slice = first_slice;
noisy_first_slice(r0:r0+3, c0:c0+3) = noisy_first_slice(r0:r0+3, c0:c0+3) + noise_block;
noisy_first_slice = uint8(max(min(noisy_first_slice, 255), 0));

% Create square kernel of size 15 with variance 1
kernel_size = 15;
variance = 1;

[x, y] = meshgrid(-(kernel_size-1)/2:(kernel_size-1)/2, ...
                  -(kernel_size-1)/2:(kernel_size-1)/2);
square_kernel = exp(-(x.^2 + y.^2) / (2 * variance));


square_kernel = square_kernel / sum(square_kernel(:));

% Fourier domain filtering with square kernel

kernel_padded = zeros(M, N);
start_row = floor((M - kernel_size)/2) + 1;
start_col = floor((N - kernel_size)/2) + 1;
kernel_padded(start_row:start_row+kernel_size-1, start_col:start_col+kernel_size-1) = square_kernel;

kernel_shifted = fftshift(kernel_padded);

fft_first = fft2(first_slice);
fft_kernel = fft2(kernel_shifted);
filtered_fft = fft_first .* fft_kernel;
filtered_slice = real(ifft2(filtered_fft));
filtered_disp = uint8(max(min(filtered_slice, 255), 0));

% Spatial domain filtering with Gaussian kernel
sigma = 1;
gauss_filtered = imgaussfilt(first_slice, sigma);
gauss_disp = uint8(max(min(gauss_filtered, 255), 0));
figure('Position', [100, 100, 1200, 400]);
subplot(1, 3, 1);
imshow(uint8(first_slice));
title('Original Image', 'FontSize', 12);

subplot(1, 3, 2);
imshow(noisy_first_slice);
title('Noisy Image (center 4x4, Var=15)', 'FontSize', 12);
hold on;
rectangle('Position', [c0, r0, 4, 4], 'EdgeColor', 'r', 'LineWidth', 2);
hold off;

subplot(1, 3, 3);
imshow(filtered_disp);
title('FFT Filtered (15x15 square kernel)', 'FontSize', 12);

figure('Position', [100, 100, 1000, 400]);

subplot(1, 2, 1);
imshow(filtered_disp);
title('Square Kernel via FFT (variance=1)', 'FontSize', 12);

subplot(1, 2, 2);
imshow(gauss_disp);
title('Gaussian Filter via imgaussfilt (σ=1)', 'FontSize', 12);


figure('Position', [100, 100, 1200, 400]);

subplot(1, 3, 1);
diff_image = abs(double(filtered_disp) - double(gauss_disp));
imshow(diff_image, []);
title('Difference (FFT - Spatial)', 'FontSize', 12);
colorbar;

subplot(1, 3, 2);
mesh(x, y, square_kernel);
title('15x15 Square Kernel (variance=1)', 'FontSize', 12);
xlabel('x'); ylabel('y'); zlabel('Weight');

subplot(1, 3, 3);
kernel_fft_show = fftshift(abs(fft2(square_kernel, 256, 256)));
imagesc(kernel_fft_show);
title('Frequency Response of Kernel', 'FontSize', 12);
colorbar;
axis square;


%% Q2
clc;
addpath('E:\6th Semester\MISP Lab\MyLab\LAB8\Lab 8_data\S2_Q2_utils');
img = imread("E:\6th Semester\MISP Lab\MyLab\LAB8\Lab 8_data\S2_Q2_utils\t2.jpg");
first_slice = double(img(:,:,1));
[M, N] = size(first_slice);
h = Gaussian(1.2,[256,256]);
H = fft2(h);
G = conv2(first_slice, h, 'same');
F_hat = fftshift(real(ifft2(fft2(G) ./ H))) ;

G_disp     = uint8( max(min(G,    255), 0) );
Fhat_disp  = uint8( max(min(F_hat,255), 0) );
orig_disp  = uint8( max(min(first_slice,    255), 0) );

figure;
subplot(1,3,1);
imshow(orig_disp);
title('Original f');

subplot(1,3,2);
imshow(G_disp);
title(['Blurred G']);

subplot(1,3,3);
imshow(Fhat_disp);
title('Recovered F\_hat = G ./ H');

G_noisy = G + sqrt(0.001) * randn(size(G));
F_hat_noisy = fftshift(real(ifft2( fft2(G_noisy) ./ H )));
Fhat_noisy_disp = uint8( max(min(F_hat_noisy,255),0) );

figure;
subplot(1,3,1);
imshow(orig_disp);
title('Original f');

subplot(1,3,2);
imshow(Fhat_disp);
title('Recovered (no noise)');

subplot(1,3,3);
imshow(Fhat_noisy_disp);
title('Recovered (with AWGN, var=0.001)');

%% Q3
clc; clear;
img = imread("E:\6th Semester\MISP Lab\MyLab\LAB8\Lab 8_data\S2_Q2_utils\t2.jpg");
f = double(img(:,:,1));
f = imresize(f, [64 64]);
N = 64;

h = [0 1 0;
     1 2 1;
     0 1 0];

h = h / sum(h(:));   % optional normalization

f_vec = f(:);

D = zeros(N*N, N*N);

for i = 1:N
    for j = 1:N
        
        % impulse image at (i,j)
        delta = zeros(N,N);
        delta(i,j) = 1;
        
        % circular convolution with kernel
        conv_result = conv2(delta, h, 'same');
        
        % vectorize and assign as column
        col_index = (j-1)*N + i;
        D(:, col_index) = conv_result(:);
    end
end
g = D * f_vec;
g_noisy = g + 0.05 * randn(size(g));
f_hat = pinv(D) * g_noisy;
f_hat_img = reshape(f_hat, N, N);
figure;
subplot(1,3,1);
imshow(uint8(f));
title('Original');
subplot(1,3,2);
imshow(uint8(reshape(g, N, N)));
title('Blurred');
subplot(1,3,3);
imshow(uint8(f_hat_img));
title('Reconstructed');

%% Q4
clc;
img = imread('S2_Q2_utils/t2.jpg');
first_slice = double(img(:,:,1));
downsampled = imresize(first_slice, 0.25);


% Defining a zero Matrix:
K = zeros(64*64,1);

% Defining h:
h_mat = [0 1 0 1 2 1 0 1 0];
K(1:9) = h_mat;

% Transforming Matrices into columnar format:
K_vecotrized = K;
f_vectorized = downsampled(:);

% Initializing required matrices:
D = zeros(64 * 64, 64 * 64);
Conv = zeros(1,1);

for k = 0:4095
    D(:, k+1) = circshift(K_vecotrized, k);
end

G = D * f_vectorized;

G_noisy = G + 0.05 * randn(size(G));

% Gradient Descent Parameters
beta = 0.01;
max_iter = 100;  % or adjust as needed
f_k = zeros(size(f_vectorized));  % f_0 = 0

for iter = 1:max_iter
    gradient = D' * (G_noisy - D * f_k);
    f_k = f_k + beta * gradient;
end

% Final reconstructed image
F_reconstructed = reshape(f_k, 64, 64);


figure;
subplot(1,2,1);
imshow(uint8(downsampled));
subplot(1,2,2);
imshow(uint8(F_reconstructed));


