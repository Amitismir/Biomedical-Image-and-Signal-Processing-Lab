%% Loading Data 
clc; 
IMG = imread("C:\Users\rakyn\OneDrive\Desktop\TERM6\MISP_LAB\LAB7\Data\S1_Q4_utils\ct.jpg"); 
IMG = im2double(IMG); 
IMG = IMG(:,:,1); 

%% Shifting Image 
[M,N,C]=size(IMG);

delta_x=20;
delta_y=40;

%frequency grids
[u,v]=meshgrid(0:N-1,0:M-1);
u = ifftshift(u - floor(N/2)); 
v = ifftshift(v - floor(M/2)); 

%shift kernel
shift_kernel = exp(-1i*2*pi*(u*delta_x/N + v*delta_y/M)); 

shifted_img=zeros(size(IMG));
for c = 1:C 
    F = fft2(IMG(:,:,c)); 
    F_shifted = F .* shift_kernel; 
    shifted_img(:,:,c) = real(ifft2(F_shifted)); 
end 
figure; 
subplot(1,3,1); 
imshow(IMG); 
title('Original Image'); 
 
subplot(1,3,2); 
imshow(shifted_img); 
title('Shifted Image (20 right, 40 down)'); 

subplot(1,3,3); 
plot(abs(fft(shift_kernel))); 
title('Magnitude of Fourier Shift Kernel'); 
colormap jet; colorbar; 

%% P4_2_Rotating IMG
 
thta=30;
img_rotated = imrotate(IMG, thta, 'bilinear', 'crop'); 

% fft of rotated image
f_rIMG=fft2(ifftshift(img_rotated));
f_rTMG_shifted=fftshift(f_rIMG); 

% undo rotation in freq domain 
F_unrotated = imrotate(f_rTMG_shifted, -thta, 'bilinear', 'crop'); 

F_unrotated_unshifted = ifftshift(F_unrotated); 
img_recovered = fftshift(real(ifft2(F_unrotated_unshifted))); 
 
% Step 6: Visualization 
figure; 
 
subplot(2,3,1); 
imshow(IMG); title('Original Image'); 
 
subplot(2,3,2); 
imshow(img_rotated); title('Rotated (Spatial Domain)'); 
 
subplot(2,3,3); 
imshow(img_recovered, []); title('Recovered via Inverse Rotation in FFT'); 
 
subplot(2,3,4); 
imagesc(log(1 + abs(fftshift(fft2(IMG))))); axis image off; 
title('FT of Original'); 
 
subplot(2,3,5); 
imagesc(log(1 + abs(f_rTMG_shifted))); axis image off; 
title('FT of Rotated Image'); 
 
subplot(2,3,6); 
imagesc(log(1 + abs(F_unrotated ))); axis image off; 
title('FT after -30° Rotation'); 
colormap gray;

%% Loading image p5
clc; 
IMG = imread("C:\Users\rakyn\OneDrive\Desktop\TERM6\MISP_LAB\LAB7\Data\S1_Q5_utils\t1.jpg"); 
IMG = im2double(IMG); 
IMG = IMG(:,:,1); 

clc; 
 
figure; 
subplot(1, 4, 1); 
imshow(IMG); 
title('Original Image'); 
 
% Vertical derivative (dy) 
Ver_img = circshift(IMG, [-1, 0]) - circshift(IMG, [1, 0]); 
 
% Horizontal derivative (dx) 
Hor_img = circshift(IMG, [0, -1]) - circshift(IMG, [0, 1]); 

% Step 3: Compute Gradient Magnitude 
Gradient = sqrt(double(Hor_img).^2 + double(Ver_img).^2); 
 
 
% Display the Ver_img derivative 
subplot(1, 4, 2); 
imshow(Ver_img); 
title('Vertical Derivative'); 
 
% Display the horizontal derivative 
subplot(1, 4, 3); 
imshow(Hor_img); 
title('Horizontal Derivative'); 
 
% Display the gradient magnitude 
subplot(1, 4, 4); 
imshow(Gradient); 
title('Gradient Magnitude'); 
%% P6

clc; 
% Apply Sobel edge detection 
edges_sobel = edge(IMG, 'sobel'); 
 
% Apply Canny edge detection 
edges_canny = edge(IMG, 'canny', [0.05 0.2]); 
 
% Plot results 
figure; 
 
subplot(1, 4, 1); 
imshow(IMG); 
title('Original Grayscale Image'); 
 
subplot(1, 4, 2); 
imshow(Gradient); 
title('Gradient Magnitude'); 
 
subplot(1, 4, 3); 
imshow(edges_sobel); 
title('Sobel Edge Detection'); 
 
subplot(1, 4, 4); 
imshow(edges_canny); 
title('Canny Edge Detection'); 

