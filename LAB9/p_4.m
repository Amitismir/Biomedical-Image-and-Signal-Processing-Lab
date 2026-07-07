clc;
% assume volume is loaded in workspace 
[r, c, d] = size(volume);

disp('dims are:')
disp(r)
disp(c)
% reshape so fcm works (needs 2d)
data = double(reshape(volume, r*c, 3));

disp('data size before fcm:')
disp(size(data))


k = 6; % number of clusters
[cents, U] = fcm(data, k, [2.0, 100, 1e-5, 0]);
disp('fcm finished!')
% find max for each pixel
[m_val, lbls] = max(U);

%disp(size(lbls))

% back to 2d image format
res = reshape(lbls, r, c);
s1 = volume(:,:,1); % just take the first slice

figure;
for i = 1:k 
m = (res == i);

    temp = zeros(r, c, 'uint8');
    
temp(m) = s1(m); % put original pixels where mask is 1


    subplot(2,3,i);
imshow(temp, []);
    title(['c ' num2str(i)]);
end

disp('done')