clc;
clear;
%% Q1
img = imread('S3_Q1_utils/thorax_t1.jpg');
I = double(img(:,:,1));        
[h, w] = size(I);


seed_lung  = [90, 90];       % example lung center (row, col)
I_lung     = I(seed_lung(1), seed_lung(2));

seed_lung2  = [90, 180];       % example lung center (row, col)
I_lung2     = I(seed_lung2(1), seed_lung2(2));

seed_liver = [140, 125];       % example liver center (row, col)
I_liver    = I(seed_liver(1), seed_liver(2));

delta_lung      = 15;
th_low_lung     = I_lung - delta_lung;
th_high_lung    = I_lung + delta_lung;

th_low_lung2     = I_lung2 - delta_lung;
th_high_lung2    = I_lung2 + delta_lung;

delta_liver     = 20;
th_low_liver    = I_liver - delta_liver;
th_high_liver   = I_liver + delta_liver;

mask_lung  = regionGrow(I, seed_lung,  th_low_lung,  th_high_lung);
mask_lung2  = regionGrow(I, seed_lung2,  th_low_lung2,  th_high_lung2);
mask_liver = regionGrow(I, seed_liver, th_low_liver, th_high_liver);

I_norm = mat2gray(I);               
RGB    = repmat(I_norm, [1 1 3]);   

RGB_lung = RGB;
RGB_lung(:,:,2) = RGB_lung(:,:,2) + 0.6 * mask_lung+0.6 * mask_lung2;
RGB_lung(RGB_lung>1) = 1;           

RGB_liver = RGB;
RGB_liver(:,:,2) = RGB_liver(:,:,2) + 0.6 * mask_liver;
RGB_liver(RGB_liver>1) = 1;

figure;
imshow(RGB_lung);
title('Lung Region Segmentation');

figure;
imshow(RGB_liver);
title('Liver Region Segmentation');
%% Q2
Img1 = imread("S3_Q2_utils\pd.jpg"); Img1 = Img1(:,:,1);
Img2 = imread("S3_Q2_utils\t1.jpg"); Img2 = Img2(:,:,1);
Img3 = imread("S3_Q2_utils\t2.jpg"); Img3 = Img3(:,:,1);
volume = cat(3, Img1, Img2, Img3);

[m, n, ~] = size(volume);

data = double(reshape(volume, [], 3)); 

num_clusters = 6;
[labels, ~] = kmeans(data, num_clusters, 'Replicates', 5);

segmented_image = reshape(labels, m, n);

[m, n] = size(segmented_image);

slice1 = volume(:,:,1);  % Just once outside the loop
figure;
for k = 1:num_clusters
    mask = (segmented_image == k);
    
    cluster_img = zeros(m, n, 'uint8');
    cluster_img(mask) = slice1(mask);
    
    subplot(2,3,k);
    imshow(cluster_img, []);
    title(['Cluster ' num2str(k)]);
end


%% Functions 
function mask = regionGrow(I, seed, th_low, th_high)
    [h, w] = size(I);
    mask    = false(h, w);
    queue   = seed;
    head    = 1;
    while head <= size(queue,1)
        x = queue(head,1);
        y = queue(head,2);
        head = head + 1;
        % check bounds
        if x<1 || x>h || y<1 || y>w, continue; end
        if mask(x,y), continue; end
        val = I(x,y);
        if val >= th_low && val <= th_high
            mask(x,y) = true;
            % enqueue 4 neighbors
            queue(end+1:end+4, :) = [ ...
                x+1, y; ...
                x-1, y; ...
                x, y+1; ...
                x, y-1  ...
            ];
        end
    end
end
