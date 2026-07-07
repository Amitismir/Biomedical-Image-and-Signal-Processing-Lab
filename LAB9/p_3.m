 clc;
Img1 = imread("C:\Users\rakyn\OneDrive\Desktop\TERM6\MISP_LAB\Lab 9\S3_Q2_utils\pd.jpg"); Img1 = Img1(:,:,1);
Img2 = imread("C:\Users\rakyn\OneDrive\Desktop\TERM6\MISP_LAB\Lab 9\S3_Q2_utils\t1.jpg"); Img2 = Img2(:,:,1);
Img3 = imread("C:\Users\rakyn\OneDrive\Desktop\TERM6\MISP_LAB\Lab 9\S3_Q2_utils\t2.jpg"); Img3 = Img3(:,:,1);

%% Concatenating Three Slices
clc;

volume = cat(3, Img1, Img2, Img3);

 %% Segmenting Data Into 6 Clusters
clc;

[m, n, ~] = size(volume);

data = double(reshape(volume, [], 3));

num_clusters = 6;
[labels, ~] = kmeans(data, num_clusters, 'Replicates', 5);

segmented_image = reshape(labels, m, n);

[m, n] = size(segmented_image);

slice1 = volume(:,:,1); % Just once outside the loop
figure;
for k = 1:num_clusters
 mask = (segmented_image == k);

 cluster_img = zeros(m, n, 'uint8');
 cluster_img(mask) = slice1(mask);
 subplot(2,3,k);
 imshow(cluster_img, []);
 title(['Cluster ' num2str(k)]);
end