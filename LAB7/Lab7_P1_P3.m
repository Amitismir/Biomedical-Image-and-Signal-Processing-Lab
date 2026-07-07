clc;
clear;
%% Q1
IMAGE = imread("E:\6th Semester\MISP Lab\MyLab\LAB7\Lab 7_data\S1_Q1_utils\t1.jpg");
figure;
imshow(IMAGE);
title('Original Image');

first_slice = IMAGE(:,:,1);
rowfft128 = double(first_slice(128, :));
X = fft(rowfft128);

magnitude = abs(X);
phase = angle(X);

N = length(rowfft128);
f = (0:N-1)/N;  

figure;

subplot(2,1,1);
plot(f, magnitude);
title('Magnitude of DFT (128^{th} row)');
xlabel('Normalized Frequency');
ylabel('|X(f)|');

subplot(2,1,2);
plot(f, phase);
title('Phase of DFT (128^{th} row)');
xlabel('Normalized Frequency');
ylabel('∠X(f) (radians)');

I = double(first_slice);

logMag = log(1 + abs(fftshift(fft2(I))));

figure;

subplot(1,2,1);
imshow(first_slice);
title('Original Image');

subplot(1,2,2);
imshow(logMag, []);
title('Log‑Magnitude of 2D FFT');

%% Q2
N  = 256;       
r  = 15;         
cx = N/2;        
cy = N/2;        

[y, x] = ndgrid(1:N, 1:N);
G = (x - cx).^2 + (y - cy).^2 <= r^2;

F = zeros(N, N);

F(50, 100) = 1;   
F(48, 120) = 2;   

convGF = fftshift(real(ifft2(fft2(double(F)) .* fft2(double(G)))));


subplot(1,3,1);
imshow(G);
title('Image G (circle)');

subplot(1,3,2);
imagesc(F);
axis image off;
colormap gray;
title('Image F (two points)');

subplot(1,3,3);
imagesc(convGF);
axis image off;
colormap gray;
colorbar;
title('Convolution F * G');


img2 = imread("E:\6th Semester\MISP Lab\MyLab\LAB7\Lab 7_data\S1_Q2_utils\pd.jpg");

img2_slice1 = double(img2(:, :, 1));

FG = fft2(double(G));         
Fslice1 = fft2(img2_slice1);       
conv_freq_real =fftshift(real(ifft2(Fslice1 .* FG)));

figure;

subplot(1,2,1);
imagesc(img2_slice1);    
axis image off;
colormap gray;
title('Original Image');

subplot(1,2,2);
imagesc(conv_freq_real); 
axis image off;
colormap gray;
title('ifft2(FFT(img)*FFT(G))');
colorbar;

%% Q3

img3 = imread("E:\6th Semester\MISP Lab\MyLab\LAB7\Lab 7_data\S1_Q3_utils\ct.jpg");

img3_slice1 = double(img3(:,:,1));

% FFT of image and shift DC to center
FFT_img3 = fftshift(fft2(img3_slice1));

% Zero-padding in frequency domain
FFT_padded = padarray(FFT_img3,[128 128]);

% Back to spatial domain
zoomed_img = ifft2(ifftshift(FFT_padded));

figure;

subplot(1,2,1);
imshow(img3_slice1,[]);
title('Original Image');

subplot(1,2,2);
imshow(abs(zoomed_img(129:384,129:384)),[]);
title('Zoomed Result');
